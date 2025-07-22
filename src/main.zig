//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.

const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    print("test", .{});

}

const Player = struct{
    player_num : i32,
    turns_taken : i32,
};

const Game = struct {
    player1 : Player,
    player2 : Player,
    current_turn : bool,
};

pub fn get_input() []u8
{

}

pub fn turn(player : Player, board : []u8) bool
{
    print("Player.player_num: {}\n", player.player_num);

}

pub fn start() !void
{
    var game = Game{
        .player1 = .{.player_num = 1, .turns_taken = 0},
        .player2 = .{.player_num = 2, .turns_taken = 0},
        .current_turn = true,
    };
    var board : []u8 = .{'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a',};

    print("Game.player1.player_num: {}\n", .{game.player1.player_num});

    var game_over : bool = false;
    while (!game_over)
    {
        if(game.current_turn)
        {
            game_over = turn(game.player1, board);
            game.current_turn = false;
        }
        else
        {
            game_over = turn(game.player2, board);
            game.current_turn = true;
        }

    }
}
