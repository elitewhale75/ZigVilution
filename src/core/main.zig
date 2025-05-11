const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello Doomguy.\n", .{});

    // Initialize subsystems (video, audio, renderer, gameplay)

    // Game loop, never return
}
