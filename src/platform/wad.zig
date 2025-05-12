const std = @import("std");

const WadInfo = struct {
    id: [4]u8,
    numlumps: u32,
    infotableofs: u32,
};

const FileLump = struct {
    filepos: u32,
    size: u32,
    name: [8]u8,
};

// WADFILE I/O
const LumpInfo = struct {
    name: [8]u8,
    postion: u32,
    size: u32,
};

pub fn initWad() !void {
    const iwad = try std.fs.cwd().openFile(
        "assets/DOOM.WAD",
        .{},
    );
    defer iwad.close();
}
