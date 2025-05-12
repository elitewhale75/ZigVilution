const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardOptimizeOption(.{});

    const root_source_file = b.path("src/core/main.zig");
    const video_source_file = b.path("src/platform/video.zig");
    const wad_source_file = b.path("src/platform/wad.zig");

    const raylib_dep = b.dependency("raylib_zig", .{
        .target = target,
        .optimize = mode,
    });

    const video_module = b.addModule("video", .{
        .root_source_file = video_source_file,
        .target = target,
        .optimize = mode,
    });
    const wad_module = b.addModule("wad", .{
        .root_source_file = wad_source_file,
        .target = target,
        .optimize = mode,
    });

    const app_mod = b.createModule(.{
        .root_source_file = root_source_file,
        .target = target,
        .optimize = mode,
        .imports = &.{
            .{ .name = "video", .module = video_module },
            .{ .name = "wad", .module = wad_module },
        },
    });

    const raylib = raylib_dep.module("raylib");
    const raygui = raylib_dep.module("raygui");
    const raylib_artifact = raylib_dep.artifact("raylib");

    video_module.addImport("raylib", raylib);
    app_mod.addImport("raylib", raylib);
    app_mod.addImport("raygui", raygui);
    app_mod.linkLibrary(raylib_artifact);

    const exe = b.addExecutable(.{
        .name = "zigdoom",
        .root_module = app_mod,
    });
    b.installArtifact(exe);

    // Run step
    const run_step = b.step("run", "Run Zigdoom");
    const run = b.addRunArtifact(exe);
    run_step.dependOn(&run.step);
}
