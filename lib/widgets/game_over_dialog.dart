import 'package:flutter/material.dart';
import 'package:snake/utilis/contsants.dart';

class GameOverDialog extends StatelessWidget {
  final int score;
  final bool isNewHighScore;
  final VoidCallback onRestart;
  final VoidCallback onHome;

  const GameOverDialog({
    super.key,
    required this.score,
    required this.isNewHighScore,
    required this.onRestart,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: GameColors.board,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isNewHighScore ? Colors.amber : GameColors.snakeHead, width: 2),
      ),
      title: Column(
        children: [
          if (isNewHighScore) ...[
            const Icon(Icons.emoji_events, color: Colors.amber, size: 48),
            const SizedBox(height: 8),
            const Text(
              'NEW HIGH SCORE!',
              style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            const Text(
              'Game Over!',
              style: TextStyle(color: Colors.red, fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🐍', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: GameColors.background, borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Text('Final Score', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  score.toString(),
                  style: TextStyle(
                    color: isNewHighScore ? Colors.amber : GameColors.snakeHead,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: onHome, child: const Text('Home')),
        ElevatedButton(
          onPressed: onRestart,
          style: ElevatedButton.styleFrom(backgroundColor: GameColors.snakeHead),
          child: const Text('Play Again'),
        ),
      ],
    );
  }
}
