const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .ReleaseSafe,
    });

    const par_shapes = b.dependency("par_shapes_zig", .{
        .target = target,
        .optimize = optimize,
    });

    //Copies library to root directory
    b.getInstallStep().dependOn(&b.addInstallArtifact(par_shapes.artifact("par_shapes"), .{
        .dest_dir = .{ .override = .{ .custom = "../" } },
    }).step);
}
