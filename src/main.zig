const std = @import("std");

pub fn main() anyerror!void {
    _ = cMain(@intCast(std.os.argv.len), std.os.argv.ptr);
    unreachable; // For now.
}

extern "c" fn cMain(argc: c_int, argv: [*][*:0]u8) c_int;
