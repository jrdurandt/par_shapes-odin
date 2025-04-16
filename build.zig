const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .pic = true,
    });

    const lib = b.addLibrary(.{
        .name = "par_shapes",
        .root_module = lib_mod,
        .linkage = .static,
    });

    lib.addIncludePath(b.path("src/par_shapes.h"));
    lib.addCSourceFiles(.{
        .files = &.{
            "src/par_shapes.c",
        },
        .flags = &.{
            "-fPIC",
            "-fno-sanitize=undefined",
        },
    });

    const dst = switch (target.result.os.tag) {
        .windows => "../lib/windows",
        .linux => "../lib/linux",
        .macos => "../lib/macos",
        else => unreachable,
    };

    const install_artifact = b.addInstallArtifact(lib, .{
        .dest_dir = .{ .override = .{ .custom = dst } },
    });
    b.getInstallStep().dependOn(&install_artifact.step);
}
