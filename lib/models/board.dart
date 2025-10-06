import 'piece.dart';
import 'position.dart';

class Board {
  final List<List<Piece?>> squares;

  Board() : squares = List.generate(8, (_) => List.filled(8, null));

  Piece? getPiece(Position pos) {
    if (!pos.isValid()) return null;
    return squares[pos.row][pos.col];
  }

  void setPiece(Position pos, Piece? piece) {
    if (!pos.isValid()) return;
    squares[pos.row][pos.col] = piece;
  }

  void movePiece(Position from, Position to) {
    final piece = getPiece(from);
    if (piece != null) {
      piece.hasMoved = true;
      setPiece(to, piece);
      setPiece(from, null);
    }
  }

  Board copy() {
    final newBoard = Board();
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = squares[row][col];
        if (piece != null) {
          newBoard.squares[row][col] = piece.copyWith();
        }
      }
    }
    return newBoard;
  }

  void setupInitialPosition() {
    // 흑색 기물 배치
    squares[0][0] = Piece(type: PieceType.rook, color: PieceColor.black);
    squares[0][1] = Piece(type: PieceType.knight, color: PieceColor.black);
    squares[0][2] = Piece(type: PieceType.bishop, color: PieceColor.black);
    squares[0][3] = Piece(type: PieceType.queen, color: PieceColor.black);
    squares[0][4] = Piece(type: PieceType.king, color: PieceColor.black);
    squares[0][5] = Piece(type: PieceType.bishop, color: PieceColor.black);
    squares[0][6] = Piece(type: PieceType.knight, color: PieceColor.black);
    squares[0][7] = Piece(type: PieceType.rook, color: PieceColor.black);

    for (int col = 0; col < 8; col++) {
      squares[1][col] = Piece(type: PieceType.pawn, color: PieceColor.black);
    }

    // 백색 기물 배치
    for (int col = 0; col < 8; col++) {
      squares[6][col] = Piece(type: PieceType.pawn, color: PieceColor.white);
    }

    squares[7][0] = Piece(type: PieceType.rook, color: PieceColor.white);
    squares[7][1] = Piece(type: PieceType.knight, color: PieceColor.white);
    squares[7][2] = Piece(type: PieceType.bishop, color: PieceColor.white);
    squares[7][3] = Piece(type: PieceType.queen, color: PieceColor.white);
    squares[7][4] = Piece(type: PieceType.king, color: PieceColor.white);
    squares[7][5] = Piece(type: PieceType.bishop, color: PieceColor.white);
    squares[7][6] = Piece(type: PieceType.knight, color: PieceColor.white);
    squares[7][7] = Piece(type: PieceType.rook, color: PieceColor.white);
  }

  Position? findKing(PieceColor color) {
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = squares[row][col];
        if (piece != null &&
            piece.type == PieceType.king &&
            piece.color == color) {
          return Position(row, col);
        }
      }
    }
    return null;
  }
}
