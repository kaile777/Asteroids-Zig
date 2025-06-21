const rl = @import("raylib");
const std = @import("std");
const math = std.math;

pub fn rotate_around_point(point: rl.Vector2, pivot: rl.Vector2, angle: f32) rl.Vector2 {
    const dx = point.x - pivot.x;
    const dy = point.y - pivot.y;

    const cos_angle = math.cos(angle);
    const sin_angle = math.sin(angle);

    return rl.Vector2{
        .x = pivot.x + dx * cos_angle - dy * sin_angle,
        .y = pivot.y + dx * sin_angle + dy * cos_angle,
    };
}
