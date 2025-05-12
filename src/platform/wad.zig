const std = @import("std");

const WadInfo = extern struct {
    id: [4]u8,
    numlumps: u32,
    infoTableOffset: u32,
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

var lumpInfo: []LumpInfo = null;
var numberOfLumps: u32 = 0;

pub fn initWad() !void {
    try addFile("assets/DOOM.WAD");
}

pub fn addFile(file_path: []const u8) !void {
    const iwad = try std.fs.cwd().openFile(
        file_path,
        .{ .mode = .read_only },
    );
    defer iwad.close();

    const header = try iwad.reader().readStruct(WadInfo);
    std.debug.print(
        "WAD ID:            {s}\n" ++
            "Lump Count:        {d}\n" ++
            "InfoTableOffset:   {d}\n",
        .{ header.id, header.numlumps, header.infoTableOffset },
    );
}
