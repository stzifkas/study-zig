const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator; // Page allocator is the allocator used by the Zig standard library.
    var lines = std.ArrayList([]const u8).init(allocator); // ArrayList is a dynamic array that grows as needed. We need to specify the type of the elements and the allocator to use.
    defer { // defer is used to run a block of code when the current scope (the function) is exited.
        for (lines.items) |line| allocator.free(line); // for is used to iterate over the elements of a collection. In this case, we are freeing the memory allocated for each line.
        lines.deinit(); // deinit is used to clean up the resources used by the ArrayList.
    }

    const stdin = std.io.getStdIn().reader(); // getStdIn returns a Reader that reads from standard input.
    const stdout = std.io.getStdOut().writer(); // getStdOut returns a Writer that writes to standard output.
    while (true) {
        const line = stdin.readUntilDelimiterAlloc(allocator, '\n', std.math.maxInt(usize)) catch |err| switch (err) { // readUntilDelimiterAlloc reads a line from the input until a delimiter is found. It allocates memory using the provided allocator.
            error.EndOfStream => break, // EndOfStream is returned when the end of the input is reached. It will always be the last error returned by readUntilDelimiterAlloc.
            else => return err, // If an error other than EndOfStream is returned, we return it from the function.
        };
        var line_with_delim = try allocator.alloc(u8, line.len + 1); // alloc is used to allocate memory for a given type and size. We allocate memory for the line plus the newline delimiter.
        @memcpy(line_with_delim[0..line.len], line); // memcpy is used to copy memory from one location to another. We copy the line to the new buffer.
        line_with_delim[line_with_delim.len - 1] = '\n'; // We add the newline delimiter to the end of the buffer.
        allocator.free(line); // We free the memory allocated for the original line. We don't need defers here because we are inside a loop and the memory will be freed when the loop exits.
        try lines.append(line_with_delim); // append is used to add an element to the end of the ArrayList. We add the line with the newline delimiter.
    }
    var start: usize = 0; // We will reverse the lines in place, so we need to keep track of the start and end indexes.
    var end: usize = lines.items.len;
    while (start < end) {
        end -= 1;
        const tmp = lines.items[start]; // We swap the lines at the start and end indexes.
        lines.items[start] = lines.items[end];
        lines.items[end] = tmp;
        start += 1;
    }
    var written: usize = 0; // We will write the reversed lines to standard output. We keep track of how many lines we have written.
    while (written < lines.items.len) : (written += 1) {
        const line = lines.items[written]; // We get the line at the current index.
        _ = try stdout.write(line); // We write the line to standard output. The _ is used to ignore the result of the write operation, although we could check for errors here.
    }
}
