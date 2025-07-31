const std = @import("std");
const stdin = std.io.getStdIn().reader();
const print = std.debug.print;

pub fn main() !void {
    print("test", .{});

    _ = try start();
}

const Player = struct{
    player_num : u8,
    turns_taken : i32,
};

const Game = struct {
    player1 : Player,
    player2 : Player,
    current_turn : bool,
    board : [9]u8,
    pub fn init(p1 : Player, p2 : Player) Game
    {
        return Game {
            .player1 = p1,
            .player2 = p2,
            .current_turn = true,
            .board = .{'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a',},
        };
    }
};

pub fn get_input(_ : []u8) !void
{
    var buf : [2]u8 = undefined;
    // handle when the user tries to input something too long
    _ = try stdin.readUntilDelimiterOrEof(&buf, '\n');
    print("in get_input: {s}", .{buf});
}

pub fn check_rows(_ : []u8) bool {
    return false;
}

pub fn check_cols(_ : []u8) bool {
    return false;
}

pub fn turn(_ : Player, board : []u8) !bool {
    _ = try get_input(board[0..]);
    // need to first get the input from a player
        // assign on the board
    // then need to check for a win
    return true;

}

pub fn start() !void {
    var game : Game = .init(.{.player_num = '1', .turns_taken = 0}, .{.player_num = '2', .turns_taken = 0});
    print("Game.player1.player_num: {}\n", .{game.player1.player_num});

    var game_over : bool = false;
    while (!game_over)
    {
        if(game.current_turn)
        {
            game_over = try turn(game.player1, game.board[0..]);
            game.current_turn = false;
        }
        else
        {
            game_over = try turn(game.player2, game.board[0..]);
            game.current_turn = true;
        }

    }
}
