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

pub fn check_rows(player : Player, board : []u8) bool {
    for (0..3) |row| {
        var counter : i32 = 0;
        for (0..3) |col| {
            if (board[row*3+col] == player.player_num) {
                counter += 1;
            }
        }
        if (counter == 3) {return true;}
    }
    return false;
}

pub fn check_cols(player : Player, board : []u8) bool {
    for (0..3) |row| {
        var counter : i32 = 0;
        for (0..3) |col| {
            if (board[col*3+row] == player.player_num) {
                counter += 1;
            }
        }
        if (counter == 3) {return true;}
    }
    return false;
}

pub fn check_diags(player : Player, board : []u8) bool {
    var i : usize = 0;
    var counter : i32 = 0;
    // top left to bottom right diagonal
    while (i <= 8) : (i += 2){
        if (board[i] == player.player_num) {counter += 1;}
    }
    if (counter == 3) {return true;}
    // TODO: top right to bottom left diagonal
    return false;
}

pub fn check_for_win(player : Player, board : []u8) bool {
    const win_rows = check_rows(player, board[0..]);
    const win_cols = check_cols(player, board[0..]);
    const win_diag = check_diags(player, board[0..]);
    return (win_rows or win_cols or win_diag);
}

pub fn place_on_board(index : usize, player : Player, board : []u8) void{
    while (true) {
        if (board[index - 1] == 'a'){
            board[index - 1] = player.player_num;
            print("board[value - 1]: {c}\n",.{board[index - 1]});
        }
        else {
            print("That spot has already been picked.\n",.{});
            continue;
        }
        break;
    }
}

pub fn turn(player : Player, board : []u8) !bool {
    const value = get_space();
    print("value: {}\n",.{value});
    print("board[0]: {}\n",.{board[0]});
    place_on_board(value, player, board[0..]);
    // then need to check for a win
    return check_for_win(player, board[0..]);
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
