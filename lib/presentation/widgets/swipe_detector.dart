
import 'package:flutter/material.dart';
import 'package:snake/models/direction.dart';

class SwipeDetector extends StatelessWidget {
  final Widget child;
  final Function(Direction) onSwipe;
  final double swipeThreshold;

  const SwipeDetector({super.key, required this.child, required this.onSwipe, this.swipeThreshold = 50.0});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanEnd: (details) {
        final velocity = details.velocity.pixelsPerSecond;
        final dx = velocity.dx;
        final dy = velocity.dy;

        if (dx.abs() > dy.abs()) {
          if (dx.abs() > swipeThreshold) {
            if (dx > 0) {
              onSwipe(Direction.right);
            } else {
              onSwipe(Direction.left);
            }
          }
        } else {
          if (dy.abs() > swipeThreshold) {
            if (dy > 0) {
              onSwipe(Direction.down);
            } else {
              onSwipe(Direction.up);
            }
          }
        }
      },
      child: child,
    );
  }
}
