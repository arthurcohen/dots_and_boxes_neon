import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:boxes/cell.dart';
import 'package:boxes/player.dart';

class GameController extends Cubit<GameState> {
  GameController(GameState initialState) : super(initialState);

  void doPlay(Player player, int rowIndex, int columnIndex) {
    final board = state.board;

    if (board[rowIndex][columnIndex].player != Player.none) {
      return;
    }

    final score = state.score;
    board[rowIndex][columnIndex] = Cell(player);
    bool foundAnyBox = false;

    if (rowIndex % 2 == 0) {
      try {
        if (_findBoxUp(rowIndex, columnIndex, board)) {
          board[rowIndex - 1][columnIndex] = Cell(player);
          score[player] = score[player]! + 1;
          foundAnyBox = true;
        }
      } catch (e) {
        print('there is no box up');
      }
      try {
        if (_findBoxDown(rowIndex, columnIndex, board)) {
          board[rowIndex + 1][columnIndex] = Cell(player);
          score[player] = score[player]! + 1;
          foundAnyBox = true;
        }
      } catch (e) {
        print('there is no box down');
      }
    } else {
      try {
        if (_findBoxLeft(rowIndex, columnIndex, board)) {
          board[rowIndex][columnIndex - 1] = Cell(player);
          score[player] = score[player]! + 1;
          foundAnyBox = true;
        }
      } catch (e) {
        print('there is no box left');
      }
      try {
        if (_findBoxRight(rowIndex, columnIndex, board)) {
          board[rowIndex][columnIndex + 1] = Cell(player);
          score[player] = score[player]! + 1;
          foundAnyBox = true;
        }
      } catch (e) {
        print('there is no box right');
      }
    }

    final nextPlayer = foundAnyBox
        ? player
        : player == Player.red
            ? Player.blue
            : Player.red;

    Player? winner = _checkWinner(score, (board.length - 1) ~/ 2);
    if (winner != null) {
      emit(
        GameState(
          board: board,
          playerTurn: nextPlayer,
          score: score,
          winner: winner,
        ),
      );
      return;
    }

    emit(
      GameState(
        board: board,
        playerTurn: nextPlayer,
        score: score,
      ),
    );
  }

  Player? _checkWinner(Map<Player, int> score, int boardSize) {
    if (score.values.reduce((int value, int element) => value + element) ==
        boardSize * boardSize) {
      if (score[Player.red] == boardSize) {
        return Player.none;
      }

      return score[Player.red]! > score[Player.blue]!
          ? Player.red
          : Player.blue;
    }

    return null;
  }

  bool _findBoxLeft(int rowIndex, int columnIndex, List<List<Cell>> board) {
    if (board[rowIndex][columnIndex - 1].player == Player.none) {
      if (board[rowIndex - 1][columnIndex - 1].player != Player.none &&
          board[rowIndex + 1][columnIndex - 1].player != Player.none &&
          board[rowIndex][columnIndex - 2].player != Player.none) {
        return true;
      }
    }
    return false;
  }

  bool _findBoxRight(int rowIndex, int columnIndex, List<List<Cell>> board) {
    if (board[rowIndex][columnIndex + 1].player == Player.none) {
      if (board[rowIndex - 1][columnIndex + 1].player != Player.none &&
          board[rowIndex + 1][columnIndex + 1].player != Player.none &&
          board[rowIndex][columnIndex + 2].player != Player.none) {
        return true;
      }
    }
    return false;
  }

  bool _findBoxUp(int rowIndex, int columnIndex, List<List<Cell>> board) {
    if (board[rowIndex - 1][columnIndex].player == Player.none) {
      if (board[rowIndex - 1][columnIndex - 1].player != Player.none &&
          board[rowIndex - 1][columnIndex + 1].player != Player.none &&
          board[rowIndex - 2][columnIndex].player != Player.none) {
        return true;
      }
    }
    return false;
  }

  bool _findBoxDown(int rowIndex, int columnIndex, List<List<Cell>> board) {
    if (board[rowIndex + 1][columnIndex].player == Player.none) {
      if (board[rowIndex + 1][columnIndex - 1].player != Player.none &&
          board[rowIndex + 1][columnIndex + 1].player != Player.none &&
          board[rowIndex + 2][columnIndex].player != Player.none) {
        return true;
      }
    }
    return false;
  }
}

class GameState {
  final List<List<Cell>> board;
  final Player playerTurn;
  final Map<Player, int> score;
  final Player? winner;

  GameState({
    required this.board,
    required this.playerTurn,
    required this.score,
    this.winner,
  });

  factory GameState.initial(boardSize) {
    return GameState(
      playerTurn: Player.red,
      score: _buildScore(0, 0),
      board: List.generate(
        (boardSize * 2 + 1),
        (index) => List.generate(
          (boardSize * 2 + 1),
          (index) => Cell(Player.none),
        ),
      ),
    );
  }
}

Map<Player, int> _buildScore(int redPlayerScore, int bluePlayerScore) {
  return {Player.red: redPlayerScore, Player.blue: bluePlayerScore};
}
