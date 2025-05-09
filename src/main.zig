const builtin = @import("builtin");
const std = @import("std");
const log = std.log.scoped(.main);

const Launcher = @import("Launcher.zig");

pub const c = @cImport({
    @cInclude("SDL_image.h");

    @cDefine("VTEC_ZIG", "");
    @cInclude("d_player.h");
    @cInclude("i_video.h");
    @cInclude("m_random.h");
    @cInclude("s_sound.h");
    @cUndef("VTEC_ZIG");
});

pub const global_allocator = if (builtin.link_libc)
    std.heap.c_allocator
else if (builtin.target.isWasm())
    std.heap.wasm_allocator
else if (!builtin.single_threaded)
    std.heap.smp_allocator
else
    std.heap.page_allocator;

pub fn main() anyerror!u8 {
    // User presumably wants to skip the launcher.
    if (std.os.argv.len > 1) {
        _ = cMain(@intCast(std.os.argv.len), std.os.argv.ptr);
        unreachable; // For now.
    }

    var dbg_gpa: ?std.heap.DebugAllocator(.{}) = if (builtin.mode == .Debug) .{} else null;
    const gpa = if (builtin.mode == .Debug) dbg_gpa.?.allocator() else global_allocator;
    var launcher = try Launcher.init(gpa);
    defer launcher.deinit();

    if (!try launcher.loop()) {
        try launcher.saveConfig();
        return 0;
    }

    try launcher.saveConfig();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const argv = try launcher.cArguments(arena.allocator());
    _ = cMain(@intCast(argv.items.len), argv.items.ptr);
    unreachable; // For now.
}

extern "c" fn cMain(argc: c_int, argv: [*][*:0]u8) c_int;

export fn pathStem(path: [*:0]const u8, out_len: *usize) [*]const u8 {
    const slice = std.mem.sliceTo(path, 0);
    const ret = std.fs.path.stem(slice);
    out_len.* = ret.len;
    return ret.ptr;
}

fn setWindowIcon(window: *c.SDL_Window) callconv(.c) void {
    const bytes = @embedFile("viletech.png");
    const rwop = c.SDL_RWFromConstMem(bytes.ptr, @intCast(bytes.len));

    if (rwop == null) {
        log.err(
            "Failed to set window icon; {s}",
            .{std.mem.span(c.SDL_GetError())},
        );
        return;
    }

    const surface = c.IMG_LoadPNG_RW(rwop);

    if (surface == null) {
        log.err(
            "Failed to read window icon PNG: {s}",
            .{std.mem.span(c.IMG_GetError())},
        );
        return;
    }

    defer c.SDL_FreeSurface(surface);
    c.SDL_SetWindowIcon(window, surface);
}

comptime {
    @export(&setWindowIcon, .{ .name = "I_SetWindowIcon" });
}

fn boomrngRange(rng_class: c.pr_class_t, min_inclusive: c_int, max_inclusive: c_int) c_int {
    return @rem(c.P_Random(rng_class), max_inclusive) + min_inclusive;
}

fn weaponSoundRandom(player: *c.player_t, psp: *c.pspdef_t) callconv(.c) void {
    const play_globally = psp.state.*.args[0] != 0;
    var choices = std.BoundedArray(c_int, 5).init(0) catch unreachable;

    for (0..choices.buffer.len) |i| {
        if (psp.state.*.args[i] != 0) {
            choices.append(@intCast(psp.state.*.args[i])) catch unreachable;
        }
    }

    switch (choices.len) {
        0 => return,
        1 => {
            c.S_StartMobjSound(if (play_globally) null else player.mo, choices.get(0));
            return;
        },
        else => {},
    }

    if (choices.len == 0)
        return;

    const max_incl = std.math.lossyCast(c_int, choices.len - 1);
    const which = std.math.lossyCast(usize, boomrngRange(c.pr_mbf21, 0, max_incl));
    c.S_StartMobjSound(if (play_globally) null else player.mo, choices.get(which));
}

comptime {
    @export(&weaponSoundRandom, .{ .name = "A_WeaponSoundRandom" });
}
