const std = @import("std");
const log = std.log.scoped(.main);

const c = @cImport({
    @cInclude("SDL_image.h");

    @cDefine("VTEC_ZIG", "");
    @cInclude("i_video.h");
    @cUndef("VTEC_ZIG");
});

pub fn main() anyerror!void {
    _ = cMain(@intCast(std.os.argv.len), std.os.argv.ptr);
    unreachable; // For now.
}

extern "c" fn cMain(argc: c_int, argv: [*][*:0]u8) c_int;

fn setWindowIcon() callconv(.c) void {
    set_window_icon.call();
}

var set_window_icon = std.once(struct {
    fn impl() void {
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

        c.SDL_SetWindowIcon(c.sdl_window, surface);
        c.SDL_FreeSurface(surface);
    }
}.impl);

comptime {
    @export(&setWindowIcon, .{ .name = "I_SetWindowIcon" });
}
