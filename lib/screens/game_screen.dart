import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/position.dart';
import '../models/piece.dart';
import '../logic/game_logic.dart';
import '../widgets/chess_board_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState gameState;

  @override
  void initState() {
    super.initState();
    gameState = GameState.initial();
  }

  void _onSquareTapped(Position pos) {
    setState(() {
      final selectedPos = gameState.selectedPosition;
      final piece = gameState.board.getPiece(pos);

      if (selectedPos == null) {
        // 기물 선택
        if (piece != null && piece.color == gameState.currentTurn) {
          gameState.selectedPosition = pos;
          gameState.validMoves =
              GameLogic.getValidMoves(gameState.board, pos);
        }
      } else {
        // 이동 시도
        if (gameState.validMoves.contains(pos)) {
          gameState.board.movePiece(selectedPos, pos);
          gameState.switchTurn();
          GameLogic.updateGameStatus(gameState);
          gameState.deselectPiece();

          // 게임 종료 체크
          if (gameState.status == GameStatus.checkmate) {
            _showGameOverDialog('체크메이트!',
                '${gameState.winner == PieceColor.white ? "백색" : "흑색"} 승리!');
          } else if (gameState.status == GameStatus.stalemate) {
            _showGameOverDialog('스테일메이트!', '무승부입니다.');
          } else if (gameState.status == GameStatus.check) {
            _showCheckDialog();
          }
        } else if (piece != null && piece.color == gameState.currentTurn) {
          // 다른 아군 기물 선택
          gameState.selectedPosition = pos;
          gameState.validMoves =
              GameLogic.getValidMoves(gameState.board, pos);
        } else {
          // 선택 해제
          gameState.deselectPiece();
        }
      }
    });
  }

  void _showCheckDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text('체크!'),
        content: Text(
            '${gameState.currentTurn == PieceColor.white ? "백색" : "흑색"}이 체크 상태입니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                gameState = GameState.initial();
              });
            },
            child: const Text('새 게임'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('메인 메뉴'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('클래식 체스'),
        backgroundColor: Colors.brown,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  '현재 턴: ${gameState.currentTurn == PieceColor.white ? "백색" : "흑색"}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (gameState.status == GameStatus.check)
                  const Text(
                    '체크!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ChessBoardWidget(
              board: gameState.board,
              selectedPosition: gameState.selectedPosition,
              validMoves: gameState.validMoves,
              onTap: _onSquareTapped,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  gameState = GameState.initial();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text(
                '게임 재시작',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
