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

pub fn get_space() usize
{
    const input_max : u8 = 2;
    var buf : [input_max]u8 = undefined;
    // handle when the user tries to input something too long
    const result = while (true){
        const string = stdin.readUntilDelimiterOrEof(&buf, '\n') catch {
            print("Bad input, try again.\n",.{});
            continue;
        };
        const value = std.fmt.parseInt(i32, string orelse "bad", 10) catch {
            print("Not a number, try again.\n",.{});
            continue;
        };
        if (value < 1 or value > 9){
            print("Too large or too small of a number.\n",.{});
            continue;
        }
        break value;
    };
    return @intCast(result);
}

pub fn check_rows(_ : []u8) bool {
    return false;
}

pub fn check_cols(_ : []u8) bool {
    return false;
}

pub fn turn(player : Player, board : []u8) !bool {
    const value = get_space();
    // TODO: Put this into it's own "place on board" function
    print("value: {}\n",.{value});
    print("board[0]: {}\n",.{board[0]});
    while (true) {
        if (board[value - 1] == 'a'){
            board[value - 1] = player.player_num;
            print("board[value - 1]: {c}\n",.{board[value - 1]});
        }
        else {
            print("That spot has already been picked.\n",.{});
            continue;
        }
        break;
    }
    // need to first get the input from a player
        // assign on the board
    // then need to check for a win
    return true;

}

pub fn start() !void {
    var game : Game = .init(.{.player_num = '1', .turns_taken = 0}, .{.player_num = '2', .turns_taken = 0});
    print("Game.player1.player_num: {c}\n", .{game.player1.player_num});

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
