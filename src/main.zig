const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
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

pub fn print_board(board : []u8) void
{
    for (0..board.len) |element_num| {
        print("{c}", .{board[element_num]});
        if ((element_num + 1) % 3 == 0)
        {
            print("\n", .{});
        }
    }
}

pub fn get_space() usize
{
    var stdin_buffer: [10]u8 = undefined;
    var stdin = std.fs.File.stdin().reader(&stdin_buffer);
    var line_buffer: [10]u8 = undefined;
    var writer: std.io.Writer = .fixed(&line_buffer);
    const result = while(true){
        const line_length = stdin.interface.streamDelimiterLimit(&writer, '\n', .unlimited) catch |err| {
            print("Bad input, try again. err: {}\n", .{err});
            continue;
        };
        const string = line_buffer[0..line_length];
        const value = std.fmt.parseInt(i32, string, 10) catch |err| {
            print("Not a number, try again. err: {}\n",.{err});
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
    while (i <= 8) : (i += 4){
        if (board[i] == player.player_num) {counter += 1;}
    }
    if (counter == 3) {return true;}

    counter = 0;
    i = 2;
    while (i <= 6) : (i += 2) {
        if (board[i] == player.player_num) {counter += 1;}
    }
    if (counter == 3) {return true;}
    return false;
}

pub fn check_for_win(player : Player, board : []u8) bool {
    print("Checking for win...\n",.{});
    const win_rows = check_rows(player, board[0..]);
    const win_cols = check_cols(player, board[0..]);
    const win_diag = check_diags(player, board[0..]);
    return (win_rows or win_cols or win_diag);
}

pub fn place_on_board(index : usize, player : Player, board : []u8) bool{
    if (board[index - 1] == 'a'){
        board[index - 1] = player.player_num;
        return true;
    }
    else {
        print("That spot has already been picked.\n",.{});
        return false;
    }
}

pub fn turn(player : Player, board : []u8) !bool {
    var still_going = false;
    while (!still_going) {
        const value = get_space();
        still_going = place_on_board(value, player, board[0..]);
    }
    // then need to check for a win
    print_board(board[0..]);
    return check_for_win(player, board[0..]);
}

pub fn start() !void {
    var game : Game = .init(.{.player_num = '1', .turns_taken = 0}, .{.player_num = '2', .turns_taken = 0});

    var game_over : bool = false;
    while (!game_over)
    {
        if(game.current_turn)
        {
            print("Player 1 turn\n", .{});
            game_over = try turn(game.player1, game.board[0..]);
            game.current_turn = false;
        }
        else
        {
            print("Player 2 turn\n", .{});
            game_over = try turn(game.player2, game.board[0..]);
            game.current_turn = true;
        }
        if (game_over) {
            print("GAME OVER\n", .{});
        }
    }
}
