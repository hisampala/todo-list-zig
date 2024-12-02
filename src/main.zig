const std = @import("std");

var to_do_list: [][]u8 = undefined;

pub fn conditionExitPrgram(param: []u8) bool {
    return param.len == 1 and param[0] == 'x';
}
pub fn conditionAddTodoPrgram(param: []u8) bool {
    return param.len == 1 and param[0] == '1';
}

pub fn conditionGetListTodoPrgram(param: []u8) bool {
    return param.len == 1 and param[0] == '2';
}

pub fn getMenuProgram() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("\nPlease select the program \n[1]: add todo  \n[2]: list todo \n[x]: exit progran\nenter program:", .{});
}

pub fn append(allocator: *std.mem.Allocator, arr: [][]u8, value: []u8) ![][]u8 {
    var newArr: [][]u8 = try allocator.realloc(arr, arr.len + 1);
    newArr[arr.len] = value;
    return newArr;
}
pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Welcome to the ToDo program!\n", .{});
    var allocator = std.heap.page_allocator;

    while (true) {
        try getMenuProgram();
        var input: [256]u8 = undefined;
        const data_read = stdin.readUntilDelimiter(&input, '\n') catch |err| {
            std.debug.print("Error reading input: {}\n", .{err});
            return;
        };

        if (conditionExitPrgram(data_read)) {
            try stdout.print("You input 'x', exiting the program... Bye...\n", .{});
            break;
        }
        if (conditionAddTodoPrgram(data_read)) {
            var input_todo: [256]u8 = undefined;
            try stdout.print("enter todo your:", .{});
            _ = stdin.readUntilDelimiter(&input_todo, '\n') catch |err| {
                std.debug.print("Error reading todo input: {}\n", .{err});
                return;
            };
            try stdout.print("Todo added : {s}", .{input_todo});
            to_do_list = try append(&allocator, to_do_list, &input_todo);
        }
        if (conditionGetListTodoPrgram(data_read)) {
            try stdout.print("To-Do List:\n", .{});
            for (to_do_list) |item| {
                try stdout.print("Todo : {s}", .{item});
            }
        }
    }
}
