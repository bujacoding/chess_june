enum PieceType {
  pawn,
  rook,
  knight,
  bishop,
  queen,
  king,
}

enum PieceColor {
  white,
  black,
}

class Piece {
  final PieceType type;
  final PieceColor color;
  bool hasMoved;

  Piece({
    required this.type,
    required this.color,
    this.hasMoved = false,
  });

  Piece copyWith({
    PieceType? type,
    PieceColor? color,
    bool? hasMoved,
  }) {
    return Piece(
      type: type ?? this.type,
      color: color ?? this.color,
      hasMoved: hasMoved ?? this.hasMoved,
    );
  }

  String get symbol {
    switch (type) {
      case PieceType.pawn:
        return color == PieceColor.white ? '♙' : '♟';
      case PieceType.rook:
        return color == PieceColor.white ? '♖' : '♜';
      case PieceType.knight:
        return color == PieceColor.white ? '♘' : '♞';
      case PieceType.bishop:
        return color == PieceColor.white ? '♗' : '♝';
      case PieceType.queen:
        return color == PieceColor.white ? '♕' : '♛';
      case PieceType.king:
        return color == PieceColor.white ? '♔' : '♚';
    }
  }

  @override
  String toString() => '$color $type';
}
