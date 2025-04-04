const std = @import("std");
const builtin = @import("builtin");

pub const zon = @embedFile("build.zig.zon");

pub const ccdb = @import("depend/ccdb.zig");
pub const datetime = @import("depend/datetime.zig");

pub fn build(b: *std.Build) anyerror!void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const check = b.step("check", "Semantic check for ZLS");
    const test_step = b.step("test", "Run all unit tests");
    const demotest_step = b.step("demotest", "Run demo accuracy regression tests");

    const cimgui = b.dependency("cimgui", .{});
    const imgui = b.dependency("imgui", .{});
    const libcimgui = @import("depend/build.cimgui.zig").staticLib(b, target, optimize, imgui, cimgui);

    const sdl2_includes = blk: {
        const pkgconf = b.run(&.{ "pkg-config", "--cflags-only-I", "sdl2" });
        var iter = std.mem.splitScalar(u8, pkgconf, ' ');
        var seq = std.ArrayListUnmanaged([]const u8).initCapacity(b.allocator, 1) catch
            @panic("allocation failure");

        while (iter.next()) |inc_flag| {
            const trimmed = std.mem.trim(u8, inc_flag, " \n\r\t");
            const f = std.mem.trimLeft(u8, trimmed, "-I");
            libcimgui.addSystemIncludePath(.{ .cwd_relative = f });
            seq.append(b.allocator, f) catch @panic("allocation failure");
        }

        break :blk seq;
    };

    var builder = Self{
        .b = b,
        .target = target,
        .optimize = optimize,
        .check = check,
        .test_step = test_step,

        .libdumb = b.option(bool, "dumb", "Use libDUMB if available") orelse
            true,
        .libfluidsynth = b.option(bool, "fluidsynth", "Use libfluidsynth if available") orelse
            true,
        .libsdlimage = b.option(bool, "image", "Use libsdlimage if available") orelse
            true,
        .libmad = b.option(bool, "mad", "Use libmad if available") orelse
            true,
        .libportmidi = b.option(bool, "portmidi", "Use libportmidi if available") orelse
            true,
        .libvorbisfile = b.option(bool, "vorbisfile", "Use libvorbisfile if available") orelse
            true,
        .cimgui = .{ .dep = cimgui, .lib = libcimgui },
        .imgui = imgui,
        .sdl2 = .{ .includes = sdl2_includes.items },
        .viletech = if (b.build_root.handle.access("depend/viletech.ln", .{})) |_|
            b.dependency("viletech.ln", .{ .target = target, .optimize = optimize })
        else |_|
            b.dependency("viletech", .{ .target = target, .optimize = optimize }),
    };
    _ = builder.engine();

    const demotest = b.addTest(.{
        .root_source_file = b.path("demotest/main.zig"),
        .target = target,
        // Optimization level of the client gets decided by what user passes to
        // `-D`. Don't optimize the unit test binary, since it just takes more
        // time and has no benefit.
        .optimize = .Debug,
    });
    if (b.args) |args| {
        demotest.filters = args;
    }

    const run_demotest = b.addRunArtifact(demotest);
    run_demotest.has_side_effects = true;

    const dsda_doom = b.dependency("dsda-doom", .{});
    const demotest_in = b.addOptions();
    demotest_in.addOption([]const u8, "install_prefix", b.install_prefix);
    demotest_in.addOptionPath("demo_dir", dsda_doom.path("spec/support/lmps"));
    demotest.root_module.addOptions("cfg", demotest_in);

    demotest_step.dependOn(&run_demotest.step);
}

pub fn packageVersion() []const u8 {
    const zon_vers_start = std.mem.indexOf(u8, zon, ".version = ").?;
    const zon_vers_end = std.mem.indexOfPos(u8, zon, zon_vers_start, ",").?;
    const zon_vers_kvp = zon[zon_vers_start..zon_vers_end];
    return std.mem.trim(u8, zon_vers_kvp, ".version =\"");
}

pub fn pkgConfigIncludeDirs(b: *std.Build, lib_name: []const u8) []const []const u8 {
    var seq = std.ArrayListUnmanaged([]const u8).initCapacity(b.allocator, 2) catch
        @panic("allocation failure");

    const pkgconf = b.run(&.{ "pkg-config", "--cflags-only-I", lib_name });
    var iter = std.mem.splitScalar(u8, pkgconf, ' ');

    while (iter.next()) |inc_flag| {
        const trimmed = std.mem.trim(u8, inc_flag, " \n\r\t");
        const f = std.mem.trimLeft(u8, trimmed, "-I");
        seq.append(b.allocator, f) catch @panic("allocation failure");
    }

    return seq.toOwnedSlice(b.allocator) catch @panic("allocation failure");
}

pub const TranslateCPostprocess = struct {
    step: std.Build.Step,
    input: std.Build.LazyPath,
    output: std.Build.LazyPath,
    callback: *const fn (*TranslateCPostprocess, [:0]u8) anyerror![]const u8,

    pub fn init(
        b: *std.Build,
        name: []const u8,
        input: std.Build.LazyPath,
        output: std.Build.LazyPath,
        callback: *const fn (*TranslateCPostprocess, [:0]u8) anyerror![]const u8,
    ) *TranslateCPostprocess {
        const ret = b.allocator.create(TranslateCPostprocess) catch
            @panic("allocation failure");
        ret.* = TranslateCPostprocess{
            .step = std.Build.Step.init(.{
                .id = .custom,
                .name = name,
                .owner = b,
                .makeFn = make,
            }),
            .input = input,
            .output = output,
            .callback = callback,
        };

        return ret;
    }

    pub fn make(step: *std.Build.Step, opts: std.Build.Step.MakeOptions) anyerror!void {
        const self: *TranslateCPostprocess = @fieldParentPtr("step", step);
        const in_path = self.input.getPath2(step.owner, step);

        opts.progress_node.setEstimatedTotalItems(3);

        var in_file = try std.fs.openFileAbsolute(in_path, .{});
        defer in_file.close();
        opts.progress_node.completeOne();

        var text_buf = std.ArrayList(u8).init(step.owner.allocator);
        try in_file.reader().readAllArrayList(&text_buf, 1024 * 1024);
        const text = try text_buf.toOwnedSliceSentinel(0);
        defer step.owner.allocator.free(text);
        opts.progress_node.completeOne();

        var hasher = std.hash.SipHash128(1, 3)
            // Test vectors from reference implementation.
            // https://github.com/veorq/SipHash/blob/master/vectors.h
            .init("\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f");
        std.hash.autoHashStrat(&hasher, text, .Deep);
        const checksum = hasher.finalResult();

        const hash_str = std.fmt.bytesToHex(checksum, .lower);

        const out_path = self.output.getPath2(step.owner, step);

        var out_file = if (std.fs.openFileAbsolute(out_path, .{ .mode = .read_write })) |o| blk: {
            defer o.close();
            var buf: [1024]u8 = undefined;
            defer opts.progress_node.completeOne();
            const line0 = try o.reader().readUntilDelimiterOrEof(buf[0..], '\n') orelse
                break :blk o;

            const hash = std.mem.trimLeft(u8, line0, "/ ");

            if (std.mem.eql(u8, hash, hash_str[0..])) {
                return; // Cache hit.
            }

            // Truncate the previous version.
            break :blk try std.fs.createFileAbsolute(out_path, .{});
        } else |err| blk: {
            switch (err) {
                error.FileNotFound => {
                    break :blk try std.fs.createFileAbsolute(out_path, .{});
                },
                else => return err,
            }
        };
        defer out_file.close();

        opts.progress_node.increaseEstimatedTotalItems(2);
        const final = try self.callback(self, text);
        defer if (final.ptr != text.ptr) step.owner.allocator.free(final);
        opts.progress_node.completeOne();

        try out_file.writer().print("// {s}\n{s}", .{ hash_str, final });
        opts.progress_node.completeOne();
    }
};

const Self = @This();

b: *std.Build,
target: std.Build.ResolvedTarget,
optimize: std.builtin.OptimizeMode,
check: *std.Build.Step,
test_step: *std.Build.Step,

libdumb: bool,
libfluidsynth: bool,
libsdlimage: bool,
libmad: bool,
libportmidi: bool,
libvorbisfile: bool,
cimgui: struct { dep: *std.Build.Dependency, lib: *std.Build.Step.Compile },
imgui: *std.Build.Dependency,
sdl2: struct { includes: []const []const u8 },
viletech: *std.Build.Dependency,

pub fn engine(self: *Self) *std.Build.Step.Compile {
    const cfg_hdr = configHeader(self);
    const c_lib = self.cStaticLibrary(cfg_hdr);
    const meta_info = self.metainfo();

    const exe_options = std.Build.ExecutableOptions{
        .name = "vileboom",
        .root_source_file = self.b.path("src/main.zig"),
        .target = self.target,
        .optimize = self.optimize,
    };

    const exe = self.b.addExecutable(exe_options);
    const exe_check = self.b.addExecutable(exe_options);
    self.check.dependOn(&exe_check.step);

    self.exeCommon(exe, cfg_hdr);
    exe.root_module.addOptions("meta", meta_info);
    exe.linkLibrary(c_lib);

    self.exeCommon(exe_check, cfg_hdr);
    exe_check.root_module.addOptions("meta", meta_info);

    const datawad = @import("build.data.zig").data(self.b, self.target, cfg_hdr);
    exe.step.dependOn(&datawad.step);
    self.b.getInstallStep().dependOn(&datawad.step);
    self.b.installArtifact(exe);

    const utests = self.b.addTest(.{
        .name = "vileboom-test",
        .link_libc = true,
        .link_libcpp = true,
        .filters = if (self.b.args) |args| args else &.{},
        .target = self.target,
        .optimize = self.optimize,
        .root_source_file = self.b.path("src/main.zig"),
    });
    self.exeCommon(utests, cfg_hdr);
    utests.root_module.addOptions("meta", meta_info);
    utests.linkLibrary(c_lib);
    utests.root_module.addAnonymousImport("SWITCHES", .{
        .root_source_file = self.b.path("prboom2/data/lumps/switches.lmp"),
    });
    const run_tests = self.b.addRunArtifact(utests);
    run_tests.setCwd(self.b.path("zig-out"));
    self.test_step.dependOn(&run_tests.step);

    // Some tools (e.g. zig translate-c) require access to config.h. Put it in a
    // convenient location so there's no need to dig through the .zig-cache.
    const install_cfgh = self.b.addInstallHeaderFile(cfg_hdr.getOutput(), "./config.h");
    exe.step.dependOn(&install_cfgh.step);

    ccdb.createStep(self.b, "ccdb", .{
        .targets = &[1]*std.Build.Step.Compile{exe},
    });

    return exe;
}

fn exeCommon(
    self: *Self,
    exe: *std.Build.Step.Compile,
    cfg_hdr: *std.Build.Step.ConfigHeader,
) void {
    exe.root_module.addConfigHeader(cfg_hdr);
    exe.step.dependOn(&cfg_hdr.step);

    exe.root_module.addAnonymousImport("viletech.png", .{
        .root_source_file = self.viletech.path("assets/viletech.png"),
    });

    exe.addIncludePath(self.b.path("prboom2/src"));
    exe.addIncludePath(cfg_hdr.getOutput().dirname());

    exe.linkLibC();
    exe.linkLibCpp();

    if (self.target.result.os.tag == .linux) {
        exe.linkSystemLibrary2("alsa", .{
            .needed = true,
            .preferred_link_mode = .static,
            .use_pkg_config = .yes,
        });

        exe.linkSystemLibrary("unwind"); // For Wasmer
    }

    for ([_][]const u8{
        "GL",
        "GLU",
        "ogg",
        "SDL2-2.0",
        "SDL2_mixer",
        "sndfile",
        "z",
        "zip",
    }) |libname| {
        exe.linkSystemLibrary2(libname, .{
            .needed = true,
            .preferred_link_mode = .static,
            .use_pkg_config = .yes,
        });
    }

    if (self.libdumb) {
        exe.linkSystemLibrary2("dumb", .{
            .needed = true,
            .preferred_link_mode = .dynamic,
            .use_pkg_config = .yes,
        });
    }

    if (self.libfluidsynth) {
        exe.linkSystemLibrary2("fluidsynth", .{
            .needed = true,
            .preferred_link_mode = .static,
            .use_pkg_config = .yes,
        });
    }

    if (self.libmad) {
        exe.linkSystemLibrary2("mad", .{
            .needed = true,
            .preferred_link_mode = .static,
            .use_pkg_config = .yes,
        });
    }

    if (self.libportmidi) {
        exe.linkSystemLibrary2("portmidi", .{
            .needed = true,
            .preferred_link_mode = .dynamic,
            .use_pkg_config = .yes,
        });
    }

    if (self.libsdlimage) {
        exe.linkSystemLibrary2("SDL2_image", .{
            .needed = true,
            .preferred_link_mode = .static,
            .use_pkg_config = .yes,
        });
    }

    if (self.libvorbisfile) {
        for ([_][]const u8{ "vorbis", "vorbisenc", "vorbisfile" }) |libname| {
            exe.linkSystemLibrary2(libname, .{
                .needed = true,
                .preferred_link_mode = .static,
                .use_pkg_config = .yes,
            });
        }
    }

    exe.linkLibrary(self.cimgui.lib);
    exe.addSystemIncludePath(self.imgui.path("backends"));
    exe.addSystemIncludePath(self.cimgui.dep.path(""));
    exe.addSystemIncludePath(self.cimgui.dep.path("generator/output"));
}

fn configHeader(self: *Self) *std.Build.Step.ConfigHeader {
    const posix_like = switch (self.target.result.os.tag) {
        .linux => true,
        .windows => false,
        else => std.debug.panic("target not yet supported: {}", .{self.target.result}),
    };

    const wad_dir = if (posix_like)
        "/usr/local/share/games/doom"
    else
        ".";

    return self.b.addConfigHeader(.{
        .style = .{ .cmake = self.b.path("prboom2/cmake/config.h.cin") },
        .include_path = ".zig-cache/config.h",
    }, .{
        .PACKAGE_NAME = "VileBoom",
        .PACKAGE_TARNAME = "vileboom",
        .WAD_DATA = "vileboom.wad",
        .PACKAGE_VERSION = packageVersion(),
        .PACKAGE_STRING = "vileboom " ++ comptime packageVersion(),

        .DOOMWADDIR = wad_dir,
        .VTEC_ABSOLUTE_PWAD_PATH = wad_dir,

        .WORDS_BIGENDIAN = self.target.result.cpu.arch.endian() == .big,

        .HAVE_CREATE_FILE_MAPPING = self.target.result.os.tag == .windows,
        .HAVE_GETOPT = posix_like,
        .HAVE_GETPWUID = posix_like,
        .HAVE_MKSTEMP = posix_like,
        .HAVE_MMAP = posix_like,
        .HAVE_STRSIGNAL = posix_like,

        .HAVE_SYS_WAIT_H = posix_like,
        .HAVE_UNISTD_H = posix_like,
        .HAVE_ASM_BYTEORDER_H = posix_like,
        .HAVE_DIRENT_H = posix_like,

        .HAVE_LIBSDL2_IMAGE = self.libsdlimage,
        .HAVE_LIBSDL2_MIXER = true,

        .HAVE_LIBDUMB = self.libdumb,
        .HAVE_LIBFLUIDSYNTH = self.libfluidsynth,
        .HAVE_LIBMAD = self.libmad,
        .HAVE_LIBPORTMIDI = self.libportmidi,
        .HAVE_LIBVORBISFILE = self.libvorbisfile,

        // Only impose significant overhead if a possible error occurs.
        .SIMPLECHECKS = switch (self.optimize) {
            .Debug, .ReleaseSafe => true,
            .ReleaseFast, .ReleaseSmall => false,
        },
        // Extra bounds checks across C code.
        .RANGECHECK = switch (self.optimize) {
            .Debug => true,
            .ReleaseSafe, .ReleaseFast, .ReleaseSmall => false,
        },
    });
}

fn cStaticLibrary(
    self: *Self,
    cfg_hdr: *std.Build.Step.ConfigHeader,
) *std.Build.Step.Compile {
    const module = self.b.createModule(.{
        .target = self.target,
        .optimize = self.optimize,
    });

    const lib = self.b.addLibrary(.{
        .name = "vileboom",
        .linkage = .static,
        .root_module = module,
    });

    lib.linkLibC();
    lib.linkLibCpp();

    lib.addIncludePath(self.b.path("prboom2/src"));
    lib.addIncludePath(cfg_hdr.getOutput().dirname());

    var c_cxx_flags = std.ArrayListUnmanaged([]const u8).initCapacity(self.b.allocator, 10) catch
        @panic("allocation failure");
    defer c_cxx_flags.deinit(self.b.allocator);

    c_cxx_flags.appendSlice(self.b.allocator, &.{
        "-ffast-math",
        "-DHAVE_CONFIG_H",
        "-Dstricmp=strcasecmp",
        "-Dstrnicmp=strncasecmp",
    }) catch unreachable;

    for (self.sdl2.includes) |inc_path| {
        c_cxx_flags.append(self.b.allocator, "-isystem") catch
            @panic("allocation failure");
        c_cxx_flags.append(self.b.allocator, inc_path) catch
            @panic("allocation failure");
    }

    if (self.target.result.os.tag == .linux) {
        c_cxx_flags.append(self.b.allocator, "--std=gnu11") catch
            @panic("allocation failure");
    } else {
        c_cxx_flags.append(self.b.allocator, "--std=c11") catch
            @panic("allocation failure");
    }

    lib.addCSourceFiles(.{
        .root = self.b.path("prboom2/src"),
        .flags = c_cxx_flags.items,
        .files = c_src,
    });

    c_cxx_flags.append(self.b.allocator, "-fno-sanitize=undefined") catch
        @panic("allocation failure");

    lib.addCSourceFiles(.{
        .root = self.b.path("prboom2/src"),
        .files = c_src_no_ubsan,
        .flags = c_cxx_flags.items,
    });

    _ = c_cxx_flags.pop(); // --std=c11
    _ = c_cxx_flags.pop(); // -fno-sanitize=undefined
    c_cxx_flags.append(self.b.allocator, "--std=c++20") catch
        @panic("allocation failure");

    lib.addCSourceFiles(.{
        .root = self.b.path("prboom2/src"),
        .files = cxx_src,
        .flags = c_cxx_flags.items,
    });

    c_cxx_flags.append(self.b.allocator, "-fno-sanitize=undefined") catch
        @panic("allocation failure");

    lib.addCSourceFiles(.{
        .root = self.b.path("prboom2/src"),
        .files = cxx_src_no_ubsan,
        .flags = c_cxx_flags.items,
    });

    return lib;
}

fn metainfo(self: *Self) *std.Build.Step.Options {
    var ret = self.b.addOptions();

    const DateTime = datetime.DateTime;
    var compile_timestamp_buf: [64]u8 = undefined;
    const compile_timestamp = std.fmt.bufPrint(
        compile_timestamp_buf[0..],
        "{}",
        .{DateTime.now()},
    ) catch unreachable;
    ret.addOption([]const u8, "compile_timestamp", compile_timestamp);

    {
        // TODO: Jujutsu has no apparent equivalent to `rev-parse HEAD`.
        // Also, since the backend is Git, it would be nice if non-Jujutsu users
        // could just use the Git CLI itself.
        const raw = self.b.run(&.{ "jj", "--ignore-working-copy", "log", "-r", "@", "-T", "commit_id" });
        const commit_id = std.mem.trim(u8, raw, "@│~ \n\t\r");
        ret.addOption([]const u8, "commit", commit_id);
    }

    return ret;
}

fn stripStructDefaults(self: *TranslateCPostprocess, text: [:0]u8) anyerror![]const u8 {
    var ast = try std.zig.Ast.parse(self.step.owner.allocator, text, .zig);
    defer ast.deinit(self.step.owner.allocator);

    var ranges = std.ArrayList([]u8).init(self.step.owner.allocator);
    defer ranges.deinit();

    for (ast.nodes.items(.tag), 0..) |ntag, i| {
        switch (ntag) {
            .container_field_init => {
                var slice = @constCast(ast.getNodeSource(ast.nodes.get(i).data.rhs));
                slice.ptr -= 3; // ` = `
                slice.len += 3;
                ranges.append(slice) catch
                    @panic("allocation failure");
            },
            else => {},
        }
    }

    for (ranges.items) |range| {
        @memset(range, ' ');
    }

    return text;
}

// TODO: the dsda-doom code is riddled with load-bearing UB.
// Slowly clean it up and add files to this list.
const c_src = &[_][]const u8{
    "dsda.c",
    "dsda/analysis.c",
    "dsda/args.c",
    "dsda/brute_force.c",
    "dsda/build.c",
    "dsda/compatibility.c",
    "dsda/console.c",
    "dsda/cr_table.c",
    "dsda/data_organizer.c",
    "dsda/death.c",
    "dsda/deh_hash.c",
    "dsda/demo.c",
    "dsda/destructible.c",
    "dsda/endoom.c",
    "dsda/episode.c",
    "dsda/excmd.c",
    "dsda/exhud.c",
    "dsda/features.c",
    "dsda/font.c",
    "dsda/game_controller.c",
    "dsda/ghost.c",
    "dsda/gl/render_scale.c",
    "dsda/global.c",
    "dsda/hud_components/ammo_text.c",
    "dsda/hud_components/armor_text.c",
    "dsda/hud_components/announce_message.c",
    "dsda/hud_components/attempts.c",
    "dsda/hud_components/base.c",
    "dsda/hud_components/big_ammo.c",
    "dsda/hud_components/big_armor.c",
    "dsda/hud_components/big_armor_text.c",
    "dsda/hud_components/big_artifact.c",
    "dsda/hud_components/big_health.c",
    "dsda/hud_components/big_health_text.c",
    "dsda/hud_components/color_test.c",
    "dsda/hud_components/command_display.c",
    "dsda/hud_components/composite_time.c",
    "dsda/hud_components/coordinate_display.c",
    "dsda/hud_components/event_split.c",
    "dsda/hud_components/fps.c",
    "dsda/hud_components/free_text.c",
    "dsda/hud_components/health_text.c",
    "dsda/hud_components/keys.c",
    "dsda/hud_components/level_splits.c",
    "dsda/hud_components/line_display.c",
    "dsda/hud_components/line_distance_tracker.c",
    "dsda/hud_components/line_tracker.c",
    "dsda/hud_components/local_time.c",
    "dsda/hud_components/map_coordinates.c",
    "dsda/hud_components/map_time.c",
    "dsda/hud_components/map_title.c",
    "dsda/hud_components/map_totals.c",
    "dsda/hud_components/message.c",
    "dsda/hud_components/minimap.c",
    "dsda/hud_components/mobj_tracker.c",
    "dsda/hud_components/null.c",
    "dsda/hud_components/player_tracker.c",
    "dsda/hud_components/ready_ammo_text.c",
    "dsda/hud_components/render_stats.c",
    "dsda/hud_components/secret_message.c",
    "dsda/hud_components/sml_armor.c",
    "dsda/hud_components/sml_berserk.c",
    "dsda/hud_components/sector_tracker.c",
    "dsda/hud_components/speed_text.c",
    "dsda/hud_components/stat_totals.c",
    "dsda/hud_components/status.c",
    "dsda/hud_components/tracker.c",
    "dsda/hud_components/weapon_text.c",
    "dsda/animate.c",
    "dsda/id_list.c",
    "dsda/input.c",
    "dsda/key_frame.c",
    "dsda/map_format.c",
    "dsda/mapinfo.c",
    "dsda/mapinfo/doom.c",
    "dsda/mapinfo/hexen.c",
    "dsda/mapinfo/legacy.c",
    "dsda/mapinfo/u.c",
    "dsda/memory.c",
    "dsda/messenger.c",
    "dsda/mobjinfo.c",
    "dsda/mouse.c",
    "dsda/msecnode.c",
    "dsda/music.c",
    "dsda/name.c",
    "dsda/options.c",
    "dsda/palette.c",
    "dsda/pause.c",
    "dsda/pclass.c",
    "dsda/playback.c",
    "dsda/preferences.c",
    "dsda/quake.c",
    "dsda/render_stats.c",
    "dsda/save.c",
    "dsda/settings.c",
    "dsda/sfx.c",
    "dsda/skill_info.c",
    "dsda/skip.c",
    "dsda/sndinfo.c",
    "dsda/spawn_number.c",
    "dsda/split_tracker.c",
    "dsda/sprite.c",
    "dsda/state.c",
    "dsda/stretch.c",
    "dsda/text_color.c",
    "dsda/text_file.c",
    "dsda/thing_id.c",
    "dsda/time.c",
    "dsda/tracker.c",
    "dsda/tranmap.c",
    "dsda/utility.c",
    "dsda/utility/string_view.c",
    "dsda/wad_stats.c",
    "dsda/zipfile.c",
    "textscreen/txt_sdl.c",
    "doomdef.c",
    "doomstat.c",
};

const c_src_no_ubsan = &[_][]const u8{
    "dsda/aim.c",
    "dsda/configuration.c",
    "dsda/exdemo.c",
    "dsda/scroll.c",
    "MUSIC/dumbplayer.c",
    "MUSIC/flplayer.c",
    "MUSIC/madplayer.c",
    "MUSIC/midifile.c",
    "MUSIC/opl.c",
    "MUSIC/opl3.c",
    "MUSIC/oplplayer.c",
    "MUSIC/opl_queue.c",
    "MUSIC/portmidiplayer.c",
    "MUSIC/vorbisplayer.c",
    "SDL/i_main.c",
    "SDL/i_sound.c",
    "SDL/i_sshot.c",
    "SDL/i_system.c",
    "SDL/i_video.c",
    "heretic/d_main.c",
    "heretic/f_finale.c",
    "heretic/info.c",
    "heretic/in_lude.c",
    "heretic/level_names.c",
    "heretic/mn_menu.c",
    "heretic/sb_bar.c",
    "heretic/sounds.c",
    "hexen/a_action.c",
    "hexen/info.c",
    "hexen/f_finale.c",
    "hexen/h2_main.c",
    "hexen/in_lude.c",
    "hexen/p_acs.c",
    "hexen/p_anim.c",
    "hexen/p_things.c",
    "hexen/po_man.c",
    "hexen/sn_sonix.c",
    "hexen/sounds.c",
    "hexen/sv_save.c",
    "am_map.c",
    "dstrings.c",
    "d_client.c",
    "d_deh.c",
    "d_items.c",
    "d_main.c",
    "e6y.c",
    "f_finale.c",
    "f_wipe.c",
    "gl_clipper.c",
    "gl_drawinfo.c",
    "gl_fbo.c",
    "gl_light.c",
    "gl_main.c",
    "gl_map.c",
    "gl_missingtexture.c",
    "gl_opengl.c",
    "gl_preprocess.c",
    "gl_progress.c",
    "gl_shader.c",
    "gl_sky.c",
    "gl_texture.c",
    "gl_vertex.c",
    "gl_wipe.c",
    "g_game.c",
    "g_overflow.c",
    "hu_lib.c",
    "hu_stuff.c",
    "info.c",
    "i_capture.c",
    "i_glob.c",
    "lprintf.c",
    "md5.c",
    "memio.c",
    "mus2mid.c",
    "m_argv.c",
    "m_bbox.c",
    "m_cheat.c",
    "m_file.c",
    "m_menu.c",
    "m_misc.c",
    "m_random.c",
    "p_ceilng.c",
    "p_doors.c",
    "p_enemy.c",
    "p_floor.c",
    "p_genlin.c",
    "p_inter.c",
    "p_lights.c",
    "p_map.c",
    "p_maputl.c",
    "p_mobj.c",
    "p_plats.c",
    "p_pspr.c",
    "p_saveg.c",
    "p_setup.c",
    "p_sight.c",
    "p_spec.c",
    "p_switch.c",
    "p_telept.c",
    "p_tick.c",
    "p_user.c",
    "r_bsp.c",
    "r_data.c",
    "r_draw.c",
    "r_fps.c",
    "r_main.c",
    "r_patch.c",
    "r_plane.c",
    "r_segs.c",
    "r_sky.c",
    "r_things.c",
    "sc_man.c",
    "smooth.c",
    "sounds.c",
    "st_lib.c",
    "st_stuff.c",
    "s_advsound.c",
    "s_sound.c",
    "tables.c",
    "v_video.c",
    "wadtbl.c",
    "wi_stuff.c",
    "w_memcache.c",
    "w_wad.c",
    "z_bmalloc.c",
    "z_zone.c",
};

const cxx_src = &[_][]const u8{
    "dsda/ambient.cpp",
    "dsda/gameinfo.cpp",
    "dsda/mapinfo/doom/parser.cpp",
    "dsda/udmf.cpp",
    "umapinfo.cpp",
};

const cxx_src_no_ubsan = &[_][]const u8{
    "scanner.cpp",
};
