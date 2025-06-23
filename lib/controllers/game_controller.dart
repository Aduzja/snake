import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snake/models/direction.dart';
import 'package:snake/models/position.dart';
import 'package:snake/models/snake.dart';
class GameController extends ChangeNotifier {
  static const int boardSize = 20;
  static const Duration gameTick = Duration(milliseconds: 300);

  Snake _snake = Snake(
    body: const [Position(x: 10, y: 10), Position(x: 9, y: 10), Position(x: 8, y: 10)],
    direction: Direction.right,
  );

  Position? _food;
  int _score = 0;
  bool _isGameRunning = false;
  Timer? _gameTimer;

  Snake get snake => _snake;
  Position? get food => _food;
  int get score => _score;
  bool get isGameRunning => _isGameRunning;

  void startGame() {
    _resetGame();
    _generateFood();
    _isGameRunning = true;
    _startGameLoop();
    notifyListeners();
  }

  void pauseGame() {
    _isGameRunning = false;
    _gameTimer?.cancel();
    notifyListeners();
  }

  void changeDirection(Direction direction) {
    if (_isGameRunning) {
      _snake = _snake.changeDirection(direction);
    }
  }

  void _startGameLoop() {
    _gameTimer = Timer.periodic(gameTick, (timer) {
      _updateGame();
    });
  }

  void _updateGame() {
    if (!_isGameRunning) return;


    final nextHeadPosition = _getNextHeadPosition();
    if (_food != null && nextHeadPosition == _food) {
      _snake = _snake.grow();
      _score += 10;
      _generateFood();
    } else {
      _snake = _snake.move();
    }

    if (_checkCollisions()) {
      _gameOver();
      return;
    }

    notifyListeners();
  }

  Position _getNextHeadPosition() {
    final currentHead = _snake.head;

    switch (_snake.direction) {
      case Direction.up:
        return Position(x: currentHead.x, y: currentHead.y - 1);
      case Direction.down:
        return Position(x: currentHead.x, y: currentHead.y + 1);
      case Direction.left:
        return Position(x: currentHead.x - 1, y: currentHead.y);
      case Direction.right:
        return Position(x: currentHead.x + 1, y: currentHead.y);
    }
  }

  bool _checkCollisions() {
    final head = _snake.head;

    if (head.x < 0 || head.x >= boardSize || head.y < 0 || head.y >= boardSize) {
      return true;
    }

    return _snake.checkSelfCollision();
  }

  void _generateFood() {
    final random = Random();
    Position newFood;

    do {
      newFood = Position(x: random.nextInt(boardSize), y: random.nextInt(boardSize));
    } while (_snake.body.contains(newFood));

    _food = newFood;
  }

  void _gameOver() {
    _isGameRunning = false;
    _gameTimer?.cancel();
    notifyListeners();
  }

  void _resetGame() {
    _snake = Snake(
      body: const [Position(x: 10, y: 10), Position(x: 9, y: 10), Position(x: 8, y: 10)],
      direction: Direction.right,
    );
    _food = null;
    _score = 0;
    _gameTimer?.cancel();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}
