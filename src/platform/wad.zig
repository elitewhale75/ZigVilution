const std = @import("std");

// USed to read header from WAD file
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
var lumpCache: []*void = undefined; // Owner of raw lump data
//TODO: Yeah this needs to be reworked altogether at some point (custom arena?)
//TODO: Also you gotta free this dumbass
var heapAllocator: std.mem.Allocator = undefined;

pub fn initWad() !void {
    heapAllocator = std.heap.page_allocator;
    try addFile("assets/DOOM2.WAD", &heapAllocator);
    lumpCache = try heapAllocator.alloc(*void, numberOfLumps);
}

// Copy and add lump directory entry tables from WAD files to memory
// TODO: Check if iWAD file exists first
// TODO: Check if file is a valid WAD file
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

    // Walk through Info Table and add each directory entry to memory
    iwad.seekTo(header.infoTableOffset) catch |err| {
        std.debug.print("Error seeking to info table\n", .{});
        return err;
    };
    const alloc_size: u32 = numberOfLumps + header.numlumps;
    lumpInfo = try allocator.realloc(
        lumpInfo,
        alloc_size,
    );
    for (numberOfLumps..(numberOfLumps + header.numlumps)) |i| {
        const lump: FileLump = try iwad.reader().readStruct(FileLump);
        lumpInfo[i].name = lump.name;
        lumpInfo[i].handle = iwad.handle;
        lumpInfo[i].position = lump.filepos;
        lumpInfo[i].size = lump.size;
    }
    numberOfLumps += header.numlumps;
}

// Dump contents of lumpCache
fn dumpLumpCache() void {}

// Used on cache misses to load lump data to memory
fn cacheLumpData() void {}

// Free lump data from memory forcibly
fn purgeLumpCache() void {}

// API for retrieving lumps from memory
pub fn getLump(lumpName: []u8) !*void {
    std.debug.print("Retrieving lump: {s}\n", .{lumpName});
}

fn findLumpFromName(lumpName: []u8) !*LumpInfo {
    std.debug.print("Search LumpInfo for: {s}\n", .{lumpName});
}
