const std = @import("std");
const rl = @import("raylib");
const Angle = @import("Angle.zig").Angle;
const math = std.math;
const vec_helpers = @import("utils/vec_rotation.zig");
const print = std.debug.print;
const Asteroid = @import("Asteroid.zig");

const MAX_SPEED: f32 = 5.0;

// Velocity is a measure of both speed and direction
pub const SpaceShip = struct {
    color: rl.Color,
    shape: [5]rl.Vector2,
    velocity: rl.Vector2,
    position: rl.Vector2,
    // angle ship is pointing toward
    // facing toward top of screen is 0 deg
    // facing right screen is 90 deg
    facing: Angle,
    thrust: [3]rl.Vector2,

    pub const Rotate = enum {
        Left,
        Right,
    };

    pub fn init(color: rl.Color, vel: rl.Vector2, pos: rl.Vector2, shape: [5]rl.Vector2, thrust: [3]rl.Vector2) SpaceShip {
        return SpaceShip{
            .color = color,
            .velocity = vel,
            .position = pos,
            .shape = shape,
            .facing = Angle.init(0),
            .thrust = thrust,
        };
    }

    pub fn draw(self: SpaceShip, thrust: bool) void {
        rl.drawLineStrip(&self.shape, rl.Color.init(255, 255, 255, 255));
        if (thrust == true) {
            rl.drawLineStrip(&self.thrust, rl.Color.init(255, 255, 255, 255));
        }
    }

    pub fn rotate(self: *SpaceShip, rot: Rotate) void {
        var deg_angle: f32 = undefined;
        deg_angle = switch (rot) {
            Rotate.Left => -4.0,
            Rotate.Right => 4.0,
        };

        switch (rot) {
            Rotate.Left => {
                self.facing.rotateLeft(4);
            },
            Rotate.Right => {
                self.facing.rotateRight(4);
            },
        }

        //var rad_angle = undefined;
        const rad_angle = math.degreesToRadians(deg_angle);

        for (&self.shape) |*point| {
            point.* = vec_helpers.rotate_around_point(point.*, self.position, rad_angle);
        }

        // rotate thrust
        for (&self.thrust) |*point| {
            point.* = vec_helpers.rotate_around_point(point.*, self.position, rad_angle);
        }
    }

    pub fn accelerate(self: *SpaceShip, thrust: f32) void {
        // convert angle of direction to radians from degrees
        const angle_rad = self.facing.toRadians();

        // obtain acceleration
        const acceleration: rl.Vector2 = rl.Vector2{
            .x = thrust * @cos(angle_rad),
            .y = thrust * @sin(angle_rad),
        };

        // apply acceleration to current velocity
        // had to invert this shit bc of raylib
        self.velocity.x -= acceleration.y;
        self.velocity.y -= acceleration.x;

        self.velocity.x = std.math.clamp(self.velocity.x, -MAX_SPEED, MAX_SPEED);
        self.velocity.y = std.math.clamp(self.velocity.y, -MAX_SPEED, MAX_SPEED);

        // TODO: UPDATE SHIP POSITION
        self.position.x += self.velocity.x;
        self.position.y += self.velocity.y;

        // Also move the shape
        for (&self.shape) |*point| {
            point.*.x += self.velocity.x;
            point.*.y += self.velocity.y;
        }

        // move the thrust sprite
        for (&self.thrust) |*point| {
            point.*.x += self.velocity.x;
            point.*.y += self.velocity.y;
        }
    }
};

pub fn initDrawShip() SpaceShip {
    const middle_pos_x: f32 = @floatFromInt(@divFloor(rl.getScreenWidth(), 2));
    const middle_pos_y: f32 = @floatFromInt(@divFloor(rl.getScreenHeight(), 2));

    const ship_shape = [_]rl.Vector2{
        rl.Vector2.init(middle_pos_x, middle_pos_y - 20), // tip
        rl.Vector2.init(middle_pos_x - 10, middle_pos_y + 5), // left-wing
        rl.Vector2.init(middle_pos_x, middle_pos_y), // centre
        rl.Vector2.init(middle_pos_x + 10, middle_pos_y + 5), // right-wing
        rl.Vector2.init(middle_pos_x, middle_pos_y - 20), // connection
    };

    const thrust = [3]rl.Vector2{
        rl.Vector2.init(middle_pos_x - 5, middle_pos_y + 5),
        rl.Vector2.init(middle_pos_x, middle_pos_y + 15),
        rl.Vector2.init(middle_pos_x + 5, middle_pos_y + 5),
    };

    const ship = SpaceShip.init(
        rl.Color.init(255, 255, 255, 255),
        rl.Vector2.init(0, 0),
        rl.Vector2.init(middle_pos_x, middle_pos_y),
        ship_shape,
        thrust,
    );

    ship.draw(false);

    return ship;
}
