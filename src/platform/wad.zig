const std = @import("std");

const WadInfo = extern struct {
    id: [4]u8,
    numlumps: u32,
    infoTableOffset: u32,
};

const FileLump = extern struct {
    filepos: u32,
    size: u32,
    name: [8]u8,
};

// WADFILE I/O
const LumpInfo = extern struct {
    name: [8]u8,
    position: u32,
    size: u32,
    handle: i32,
};

var lumpInfo: []LumpInfo = undefined;
var numberOfLumps: u32 = 0;
var lumpCache: []*void = undefined;
var arena: std.heap.ArenaAllocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);

pub fn initWad() !void {
    const allocator = arena.allocator();
    try addFile("assets/DOOM.WAD", &allocator);
}

pub fn addFile(file_path: []const u8, allocator: *const std.mem.Allocator) !void {
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

    iwad.seekTo(header.infoTableOffset) catch |err| {
        std.debug.print("Error seeking to info table\n", .{});
        return err;
    };
    const alloc_size: u32 = (numberOfLumps + header.numlumps) * @sizeOf(LumpInfo);
    lumpInfo = try allocator.realloc(
        lumpInfo,
        alloc_size,
    );

    // Read lump info table into lumpInfo and update the amount of lumps
    for (numberOfLumps..(numberOfLumps + header.numlumps)) |i| {
        const lump: FileLump = try iwad.reader().readStruct(FileLump);
        lumpInfo[i].name = lump.name;
        lumpInfo[i].handle = iwad.handle;
        lumpInfo[i].position = lump.filepos;
        lumpInfo[i].size = lump.size;
    }

    numberOfLumps += header.numlumps;
    std.debug.print("Lump 0 Name: {s}\n", .{lumpInfo[0].name});
}
