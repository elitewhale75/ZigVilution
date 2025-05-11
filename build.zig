const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardOptimizeOption(.{});
    const root_source_file = b.path("src/core/main.zig");

    const app_mod = b.createModule(.{
        .root_source_file = root_source_file,
        .target = target,
        .optimize = mode,
    });

    const sdl_dep = b.dependency("sdl", .{
        .target = target,
        .optimize = mode,
    });

    const sdl_lib = sdl_dep.artifact("SDL3");
    app_mod.linkLibrary(sdl_lib);

    const run_step = b.step("run", "Run Zigdoom");

    const exe = b.addExecutable(.{
        .name = "zigdoom",
        .root_module = app_mod,
    });

    b.installArtifact(exe);

    const run = b.addRunArtifact(exe);
    run_step.dependOn(&run.step);
}
