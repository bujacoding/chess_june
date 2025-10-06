import 'piece.dart';
import 'board.dart';
import 'position.dart';

enum GameStatus {
  playing,
  check,
  checkmate,
  stalemate,
}

class GameState {
  final Board board;
  PieceColor currentTurn;
  GameStatus status;
  Position? selectedPosition;
  List<Position> validMoves;
  PieceColor? winner;

  GameState({
    required this.board,
    this.currentTurn = PieceColor.white,
    this.status = GameStatus.playing,
    this.selectedPosition,
    this.validMoves = const [],
    this.winner,
  });

  factory GameState.initial() {
    final board = Board();
    board.setupInitialPosition();
    return GameState(board: board);
  }

  void switchTurn() {
    currentTurn =
        currentTurn == PieceColor.white ? PieceColor.black : PieceColor.white;
  }

  void selectPiece(Position pos) {
    final piece = board.getPiece(pos);
    if (piece != null && piece.color == currentTurn) {
      selectedPosition = pos;
    }
  }

  void deselectPiece() {
    selectedPosition = null;
    validMoves = [];
  }

  GameState copy() {
    return GameState(
      board: board.copy(),
      currentTurn: currentTurn,
      status: status,
      selectedPosition: selectedPosition,
      validMoves: List.from(validMoves),
      winner: winner,
    );
  }
}
