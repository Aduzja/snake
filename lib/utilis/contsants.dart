import 'package:flutter/material.dart';

class GameColors {
  static const Color background = Color(0xFF1a1a1a);
  static const Color snakeHead = Color(0xFF4CAF50);
  static const Color snakeBody = Color(0xFF66BB6A);
  static const Color food = Color(0xFFFF5722);
  static const Color board = Color(0xFF2E2E2E);
  static const Color boardBorder = Color(0xFF4CAF50);
  static const Color text = Colors.white;
  static const Color accent = Color(0xFF8BC34A);
}

class GameSettings {
  static const int defaultBoardSize = 20;
  static const Duration defaultGameSpeed = Duration(milliseconds: 300);
  static const int pointsPerFood = 10;
}
