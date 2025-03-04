const builtin = @import("builtin");
const std = @import("std");

pub fn staticLib(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    imgui: *std.Build.Dependency,
    cimgui: *std.Build.Dependency,
) *std.Build.Step.Compile {
    _ = optimize;

    // CImGui expects to be cloned with recursive submodule initialization
    // so that it include `imgui/*.h`, but Zig package management neither supports
    // submodules nor offers any recourse. As such we copy files from the ImGui
    // revision CImGui expects to a directory that will satisfy it.

    const mkdir = b.allocator.create(MakeDir) catch
        @panic("allocation failure");
    mkdir.* = .{
        .step = std.Build.Step.init(.{
            .id = .custom,
            .name = ".zig-cache/imgui mkdir",
            .makeFn = MakeDir.make,
            .owner = b,
        }),
        .absolute_path = b.path(".zig-cache/imgui"),
        .allow_clobber = true,
    };

    const copy = b.allocator.create(OneTimeCopy) catch
        @panic("allocation failure");
    copy.* = .{
        .step = std.Build.Step.init(.{
            .id = .custom,
            .name = ".zig-cache/imgui one-time copy",
            .makeFn = OneTimeCopy.make,
            .owner = b,
        }),
        .paths = b.allocator.dupe(OneTimeCopy.Argument, &.{
            .{
                .source = imgui.path("imconfig.h"),
                .dest = b.path(".zig-cache/imgui/imconfig.h"),
            },
            .{
                .source = imgui.path("imgui.h"),
                .dest = b.path(".zig-cache/imgui/imgui.h"),
            },
            .{
                .source = imgui.path("imgui_internal.h"),
                .dest = b.path(".zig-cache/imgui/imgui_internal.h"),
            },
            .{
                .source = imgui.path("imstb_rectpack.h"),
                .dest = b.path(".zig-cache/imgui/imstb_rectpack.h"),
            },
            .{
                .source = imgui.path("imstb_textedit.h"),
                .dest = b.path(".zig-cache/imgui/imstb_textedit.h"),
            },
            .{
                .source = imgui.path("imstb_truetype.h"),
                .dest = b.path(".zig-cache/imgui/imstb_truetype.h"),
            },
        }) catch @panic("allocation failure"),
    };
    copy.step.dependOn(&mkdir.step);

    const cxx_flags: []const []const u8 = if (builtin.os.tag == .windows)
        &[_][]const u8{ "--std=c++20", "-DIMGUI_IMPL_API=extern \"C\" __declspec(dllexport)" }
    else
        &[_][]const u8{ "--std=c++20", "-DIMGUI_IMPL_API=extern \"C\"" };

    const lib = b.addStaticLibrary(.{
        .name = "cimgui",
        .target = target,
        .optimize = .ReleaseSafe,
    });

    lib.linkLibC();
    lib.linkLibCpp();

    lib.addIncludePath(b.path(".zig-cache"));
    lib.addIncludePath(b.path(".zig-cache/imgui"));

    lib.addCSourceFile(.{
        .file = cimgui.path("cimgui.cpp"),
        .flags = cxx_flags,
    });

    lib.addCSourceFiles(.{
        .root = imgui.path(""),
        .flags = cxx_flags,
        .files = &.{
            "imgui_demo.cpp",
            "imgui_draw.cpp",
            "backends/imgui_impl_sdl2.cpp",
            "backends/imgui_impl_sdlrenderer2.cpp",
            "backends/imgui_impl_opengl3.cpp",
            "imgui_tables.cpp",
            "imgui_widgets.cpp",
            "imgui.cpp",
        },
    });

    lib.step.dependOn(&copy.step);

    return lib;
}

const OneTimeCopy = struct {
    const Argument = struct {
        source: std.Build.LazyPath,
        dest: std.Build.LazyPath,
    };

    paths: []const Argument,
    step: std.Build.Step,

    fn make(step: *std.Build.Step, opts: std.Build.Step.MakeOptions) anyerror!void {
        const self: *OneTimeCopy = @fieldParentPtr("step", step);
        opts.progress_node.setEstimatedTotalItems(self.paths.len);

        for (self.paths) |arg| {
            const dst = arg.dest.getPath2(step.owner, step);

            if (std.fs.accessAbsolute(dst, .{}))
                continue
            else |_| {}

            const src = arg.source.getPath2(step.owner, step);

            std.fs.copyFileAbsolute(src, dst, .{}) catch |err| switch (err) {
                error.FileNotFound => {
                    std.log.err("file not found: {s} -> {s}", .{ src, dst });
                    return err;
                },
                else => return err,
            };
            opts.progress_node.completeOne();
        }
    }
};

const MakeDir = struct {
    step: std.Build.Step,
    absolute_path: std.Build.LazyPath,
    allow_clobber: bool = false,

    fn make(step: *std.Build.Step, opts: std.Build.Step.MakeOptions) anyerror!void {
        const self: *MakeDir = @fieldParentPtr("step", step);
        opts.progress_node.increaseEstimatedTotalItems(1);
        std.fs.makeDirAbsolute(self.absolute_path.getPath2(step.owner, step)) catch |err| switch (err) {
            error.PathAlreadyExists => {
                if (self.allow_clobber) {} else return err;
            },
            else => return err,
        };
        opts.progress_node.completeOne();
    }
};
