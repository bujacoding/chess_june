import '../models/board.dart';
import '../models/piece.dart';
import '../models/position.dart';
import '../models/game_state.dart';

class GameLogic {
  static List<Position> getValidMoves(
    Board board,
    Position from,
    {bool checkForCheck = true}
  ) {
    final piece = board.getPiece(from);
    if (piece == null) return [];

    List<Position> moves = [];

    switch (piece.type) {
      case PieceType.pawn:
        moves = _getPawnMoves(board, from, piece);
        break;
      case PieceType.rook:
        moves = _getRookMoves(board, from, piece);
        break;
      case PieceType.knight:
        moves = _getKnightMoves(board, from, piece);
        break;
      case PieceType.bishop:
        moves = _getBishopMoves(board, from, piece);
        break;
      case PieceType.queen:
        moves = _getQueenMoves(board, from, piece);
        break;
      case PieceType.king:
        moves = _getKingMoves(board, from, piece);
        break;
    }

    if (checkForCheck) {
      moves = moves.where((to) {
        return !_wouldBeInCheck(board, from, to, piece.color);
      }).toList();
    }

    return moves;
  }

  static List<Position> _getPawnMoves(Board board, Position from, Piece piece) {
    final moves = <Position>[];
    final direction = piece.color == PieceColor.white ? -1 : 1;

    // 전방 1칸
    final forward = Position(from.row + direction, from.col);
    if (forward.isValid() && board.getPiece(forward) == null) {
      moves.add(forward);

      // 처음 이동시 2칸
      if (!piece.hasMoved) {
        final forward2 = Position(from.row + direction * 2, from.col);
        if (forward2.isValid() && board.getPiece(forward2) == null) {
          moves.add(forward2);
        }
      }
    }

    // 대각선 공격
    for (final colOffset in [-1, 1]) {
      final attack = Position(from.row + direction, from.col + colOffset);
      if (attack.isValid()) {
        final target = board.getPiece(attack);
        if (target != null && target.color != piece.color) {
          moves.add(attack);
        }
      }
    }

    return moves;
  }

  static List<Position> _getRookMoves(Board board, Position from, Piece piece) {
    final moves = <Position>[];
    final directions = [
      Position(-1, 0), // 위
      Position(1, 0), // 아래
      Position(0, -1), // 왼쪽
      Position(0, 1), // 오른쪽
    ];

    for (final dir in directions) {
      Position current = from + dir;
      while (current.isValid()) {
        final target = board.getPiece(current);
        if (target == null) {
          moves.add(current);
        } else {
          if (target.color != piece.color) {
            moves.add(current);
          }
          break;
        }
        current = current + dir;
      }
    }

    return moves;
  }

  static List<Position> _getKnightMoves(
      Board board, Position from, Piece piece) {
    final moves = <Position>[];
    final offsets = [
      Position(-2, -1),
      Position(-2, 1),
      Position(-1, -2),
      Position(-1, 2),
      Position(1, -2),
      Position(1, 2),
      Position(2, -1),
      Position(2, 1),
    ];

    for (final offset in offsets) {
      final pos = from + offset;
      if (pos.isValid()) {
        final target = board.getPiece(pos);
        if (target == null || target.color != piece.color) {
          moves.add(pos);
        }
      }
    }

    return moves;
  }

  static List<Position> _getBishopMoves(
      Board board, Position from, Piece piece) {
    final moves = <Position>[];
    final directions = [
      Position(-1, -1), // 좌상
      Position(-1, 1), // 우상
      Position(1, -1), // 좌하
      Position(1, 1), // 우하
    ];

    for (final dir in directions) {
      Position current = from + dir;
      while (current.isValid()) {
        final target = board.getPiece(current);
        if (target == null) {
          moves.add(current);
        } else {
          if (target.color != piece.color) {
            moves.add(current);
          }
          break;
        }
        current = current + dir;
      }
    }

    return moves;
  }

  static List<Position> _getQueenMoves(Board board, Position from, Piece piece) {
    return [
      ..._getRookMoves(board, from, piece),
      ..._getBishopMoves(board, from, piece),
    ];
  }

  static List<Position> _getKingMoves(Board board, Position from, Piece piece) {
    final moves = <Position>[];
    final offsets = [
      Position(-1, -1),
      Position(-1, 0),
      Position(-1, 1),
      Position(0, -1),
      Position(0, 1),
      Position(1, -1),
      Position(1, 0),
      Position(1, 1),
    ];

    for (final offset in offsets) {
      final pos = from + offset;
      if (pos.isValid()) {
        final target = board.getPiece(pos);
        if (target == null || target.color != piece.color) {
          moves.add(pos);
        }
      }
    }

    return moves;
  }

  static bool _wouldBeInCheck(
      Board board, Position from, Position to, PieceColor color) {
    final testBoard = board.copy();
    testBoard.movePiece(from, to);
    return isInCheck(testBoard, color);
  }

  static bool isInCheck(Board board, PieceColor color) {
    final kingPos = board.findKing(color);
    if (kingPos == null) return false;

    final opponentColor =
        color == PieceColor.white ? PieceColor.black : PieceColor.white;

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final pos = Position(row, col);
        final piece = board.getPiece(pos);
        if (piece != null && piece.color == opponentColor) {
          final moves = getValidMoves(board, pos, checkForCheck: false);
          if (moves.contains(kingPos)) {
            return true;
          }
        }
      }
    }

    return false;
  }

  static bool isCheckmate(Board board, PieceColor color) {
    if (!isInCheck(board, color)) return false;

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final pos = Position(row, col);
        final piece = board.getPiece(pos);
        if (piece != null && piece.color == color) {
          final moves = getValidMoves(board, pos);
          if (moves.isNotEmpty) {
            return false;
          }
        }
      }
    }

    return true;
  }

  static bool isStalemate(Board board, PieceColor color) {
    if (isInCheck(board, color)) return false;

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final pos = Position(row, col);
        final piece = board.getPiece(pos);
        if (piece != null && piece.color == color) {
          final moves = getValidMoves(board, pos);
          if (moves.isNotEmpty) {
            return false;
          }
        }
      }
    }

    return true;
  }

  static void updateGameStatus(GameState state) {
    if (isCheckmate(state.board, state.currentTurn)) {
      state.status = GameStatus.checkmate;
      state.winner = state.currentTurn == PieceColor.white
          ? PieceColor.black
          : PieceColor.white;
    } else if (isStalemate(state.board, state.currentTurn)) {
      state.status = GameStatus.stalemate;
    } else if (isInCheck(state.board, state.currentTurn)) {
      state.status = GameStatus.check;
    } else {
      state.status = GameStatus.playing;
    }
  }
}
