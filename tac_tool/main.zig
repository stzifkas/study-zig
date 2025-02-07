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
        var start: usize = 0;
        var end: usize = readBytes - 1;
        while (start < end) {
            const temp = buffer[start];
            buffer[start] = buffer[end];
            buffer[end] = temp;
            start += 1;
            end -= 1;
        }

        var written: usize = 0;
        while (written < readBytes) {
            const amt = try stdout.write(buffer[written..readBytes]);
            written += amt;
        }
    }
}
