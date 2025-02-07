const std = @import("std");

pub fn main() !void {
    const args = std.os.argv;
    if (args.len < 2) {
        std.debug.print("Usage: {s} <username>\n", .{args[0]});
        return;
    }
    const argUsername = args[1];
    const length = std.mem.len(argUsername);

    var allocator = std.heap.page_allocator;
    const usernameBuffer = try allocator.alloc(u8, length);
    defer allocator.free(usernameBuffer);
    for (argUsername, 0..length) |byte, i| {
        usernameBuffer[i] = byte;
    }
    std.debug.print("Hello, {s}!\n", .{usernameBuffer});
}
