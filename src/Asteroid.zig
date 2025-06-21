const std = @import("std");
const rl = @import("raylib");
const Angle = @import("Angle.zig").Angle;
const math = std.math;
const vec_helpers = @import("utils/vec_rotation.zig");
const print = std.debug.print;

const Asteroid = struct {
    color: rl.Color,
    shape: [10]rl.Vector2,
    velocity: rl.Vector2,
    position: rl.Vector2,
    facing: Angle,

    pub fn init(color: rl.Color, shape: [10]rl.Vector2, velocity: rl.Vector2, position: rl.Vector2, facing: Angle) Asteroid {
        return Asteroid{
            .color = color,
            .velocity = velocity,
            .position = position,
            .shape = shape,
            .facing = facing,
        };
    }

    pub fn drawShip(self: Asteroid) void {
        rl.drawLineStrip(&self.shape, self.color);
    }
};
