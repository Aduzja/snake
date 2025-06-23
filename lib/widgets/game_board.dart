import 'package:flutter/material.dart';
import 'package:snake/models/position.dart';
import 'package:snake/models/snake.dart';

class GameBoard extends StatelessWidget {
  final Snake snake;
  final Position? food;
  final int boardSize;

  const GameBoard({super.key, required this.snake, this.food, this.boardSize = 20});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 2),
          color: Colors.grey[900],
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: boardSize),
          itemCount: boardSize * boardSize,
          itemBuilder: (context, index) {
            final x = index % boardSize;
            final y = index ~/ boardSize;
            final position = Position(x: x, y: y);

            return _buildCell(position);
          },
        ),
      ),
    );
  }

  Widget _buildCell(Position position) {
    Color cellColor = Colors.transparent;

    if (snake.body.contains(position)) {
      cellColor = position == snake.head ? Colors.green : Colors.lightGreen;
    }

    if (food != null && food == position) {
      cellColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.all(0.5),
      decoration: BoxDecoration(color: cellColor, borderRadius: BorderRadius.circular(2)),
    );
  }
}
