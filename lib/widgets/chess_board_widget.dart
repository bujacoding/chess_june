import 'package:flutter/material.dart';
import '../models/board.dart';
import '../models/position.dart';
import '../models/piece.dart';

class ChessBoardWidget extends StatelessWidget {
  final Board board;
  final Position? selectedPosition;
  final List<Position> validMoves;
  final Function(Position) onTap;

  const ChessBoardWidget({
    super.key,
    required this.board,
    this.selectedPosition,
    required this.validMoves,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final boardSize = size.width < size.height ? size.width : size.height - 100;

    return Center(
      child: Container(
        width: boardSize,
        height: boardSize,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.brown, width: 2),
        ),
        child: Column(
          children: List.generate(8, (row) {
            return Expanded(
              child: Row(
                children: List.generate(8, (col) {
                  final pos = Position(row, col);
                  return _buildSquare(pos);
                }),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSquare(Position pos) {
    final isLight = (pos.row + pos.col) % 2 == 0;
    final isSelected = pos == selectedPosition;
    final isValidMove = validMoves.contains(pos);
    final piece = board.getPiece(pos);

    Color bgColor;
    if (isSelected) {
      bgColor = Colors.yellow.shade600;
    } else if (isValidMove) {
      bgColor = isLight ? Colors.green.shade200 : Colors.green.shade400;
    } else {
      bgColor = isLight ? Colors.grey.shade300 : Colors.brown.shade600;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(pos),
        child: Container(
          color: bgColor,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.maxWidth < constraints.maxHeight
                  ? constraints.maxWidth
                  : constraints.maxHeight;
              return Center(
                child: piece != null
                    ? Text(
                        piece.symbol,
                        style: TextStyle(
                          fontSize: size * 0.7,
                        ),
                      )
                    : isValidMove && board.getPiece(pos) == null
                        ? Container(
                            width: size * 0.3,
                            height: size * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
              );
            },
          ),
        ),
      ),
    );
  }
}
