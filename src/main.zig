const std = @import("std");

pub fn get_menu_program() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("\nPlease select the program \n[1]: add todo  \n[2]: list todo \n[x]: exit progran\nenter program:", .{});
}

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    std.log.info("Welcome to the ToDo program!\n", .{});
    const allocator = std.heap.page_allocator;
    var list = std.ArrayList([]u8).init(allocator);
    defer list.deinit();
    while (true) {
        try get_menu_program();
        var input: [256]u8 = undefined;
        const data_read = stdin.readUntilDelimiter(&input, '\n') catch |err| {
            std.debug.print("Error reading input: {}\n", .{err});
            return;
        };
        try stdout.print("You input = {u}\n", .{data_read[0]});
        switch (data_read[0]) {
            120 => {
                std.log.info("exiting the program... Bye...\n", .{});
                break;
            },
            49 => {
                var input_todo: [256]u8 = undefined;
                try stdout.print("Enter todo :", .{});
                const todo_data = stdin.readUntilDelimiter(&input_todo, '\n') catch |err| {
                    std.log.err("Error reading todo input: {}\n", .{err});
                    return;
                };
                try list.append(todo_data);
            },
            50 => {
                try stdout.print("\n----------------- To-Do List: -----------------\n ", .{});
                for (list.items) |item| {
                    try stdout.print("Todo : {s} \n", .{item});
                }
                try stdout.print("----------------------------------------------- ", .{});
            },
            else => {
                std.log.info("You input '{s}', notfound the program... \n", .{data_read});
            },
        }
    }
}
