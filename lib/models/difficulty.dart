import 'package:flutter/material.dart';

enum Difficulty {
  easy(speed: Duration(milliseconds: 400), name: 'Easy', pointsMultiplier: 1),
  normal(speed: Duration(milliseconds: 300), name: 'Normal', pointsMultiplier: 2),
  hard(speed: Duration(milliseconds: 200), name: 'Hard', pointsMultiplier: 3),
  extreme(speed: Duration(milliseconds: 100), name: 'Extreme', pointsMultiplier: 5);

  const Difficulty({required this.speed, required this.name, required this.pointsMultiplier});

  final Duration speed;
  final String name;
  final int pointsMultiplier;

  Color get color {
    switch (this) {
      case Difficulty.easy:
        return const Color(0xFF4CAF50);
      case Difficulty.normal:
        return const Color(0xFF2196F3);
      case Difficulty.hard:
        return const Color(0xFFFF9800);
      case Difficulty.extreme:
        return const Color(0xFFF44336);
    }
  }

  IconData get icon {
    switch (this) {
      case Difficulty.easy:
        return Icons.sentiment_satisfied;
      case Difficulty.normal:
        return Icons.sentiment_neutral;
      case Difficulty.hard:
        return Icons.sentiment_dissatisfied;
      case Difficulty.extreme:
        return Icons.local_fire_department;
    }
  }
}
