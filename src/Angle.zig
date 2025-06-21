const std = @import("std");
const math = std.math;

pub const Angle = struct {
    degrees: f32,

    pub fn init(degrees: f32) Angle {
        return Angle{ .degrees = normalize(degrees) };
    }

    pub fn rotateLeft(self: *Angle, amount: f32) void {
        self.degrees = normalize(self.degrees + amount);
    }

    pub fn rotateRight(self: *Angle, amount: f32) void {
        self.degrees = normalize(self.degrees - amount);
    }

    pub fn toRadians(self: *Angle) f32 {
        return math.degreesToRadians(self.degrees);
    }

    fn normalize(deg: f32) f32 {
        var d = deg;

        // Wrap to (-180, 180]
        d = @mod(d + 180.0, 360.0);
        if (d < 0) d += 360.0;
        return d - 180.0;
    }
};
