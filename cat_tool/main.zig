const std = @import("std");

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    while (true) {
        var buffer: [1024]u8 = undefined;
        const readBytes = try stdin.read(&buffer);

        if (readBytes == 0) {
            break;
        }
        var written: usize = 0;
        while (written < readBytes) {
            const amt = try stdout.write(buffer[written..readBytes]);
            written += amt;
        }
    }
}
