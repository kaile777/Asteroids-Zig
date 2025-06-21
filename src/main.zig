/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
const lib = @import("TempConv_lib");
const std = @import("std");
const rl = @import("raylib");
const math = std.math;
const print = @import("std").debug.print;
const Angle = @import("Angle.zig").Angle;
const SpaceShip = @import("SpaceShip.zig").SpaceShip;
const ShipHelp = @import("SpaceShip.zig");

const WINDOW_HEIGHT: i32 = 1000;
const WINDOW_WIDTH: i32 = 1500;
const title: [:0]const u8 = "Asteroids | ZIG";
const score_title: [:0]const u8 = "SCORE";

// TODO: Draw random asteroids of different shapes
// TODO: Randomly move asteroids in one random straight direction
// TODO: Add physics
// TODO: Add controls for ship and exiting game
// TODO: Add collision between ship and asteroids
// TODO: Add general game logic

fn run() !void {
    rl.setTargetFPS(60);

    rl.initWindow(WINDOW_WIDTH, WINDOW_HEIGHT, title);
    defer rl.closeWindow();

    const color = rl.Color.init(0, 0, 0, 0);
    var start_game: bool = true;

    var ship: SpaceShip = undefined;
    var high_speed: bool = false;

    // loop occurs each frame (60 fps)
    // begin and clear drawing every frame
    // need to listen for keyboard input each frame
    // update ship position, rotation, and speed
    // update asteroids each frame
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        rl.clearBackground(color);

        if (start_game == true) {
            print("INITIALIZING SHIP...\n", .{});
            ship = ShipHelp.initDrawShip();
            print("SHIP INITIALIZED!\n", .{});
            start_game = false;
        } else {
            if (rl.isKeyPressed(rl.KeyboardKey.escape)) {
                rl.endDrawing();
                break;
            } else if (rl.isKeyDown(rl.KeyboardKey.a)) {
                ship.rotate(SpaceShip.Rotate.Left);
            } else if (rl.isKeyDown(rl.KeyboardKey.d)) {
                ship.rotate(SpaceShip.Rotate.Right);
            } else if (rl.isKeyDown(rl.KeyboardKey.e)) {
                high_speed = true;
            } else if (rl.isKeyDown(rl.KeyboardKey.q)) {
                high_speed = false;
            }
            if (rl.isKeyDown(rl.KeyboardKey.w)) {
                if (high_speed) {
                    ship.accelerate(0.1);
                } else {
                    ship.accelerate(0.02);
                }
            } else {
                ship.accelerate(0);
            }
        }

        if (rl.isKeyDown(rl.KeyboardKey.w)) {
            ship.draw(true);
        } else {
            ship.draw(false);
        }

        rl.endDrawing();
    }
}

pub fn main() !void {
    try run();
}
