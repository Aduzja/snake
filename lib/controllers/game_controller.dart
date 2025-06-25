import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snake/models/direction.dart';
import 'package:snake/models/position.dart';
import 'package:snake/models/snake.dart';
import 'package:snake/services/high_score_service.dart';
import 'package:snake/utilis/contsants.dart';

enum GameState { ready, running, paused, gameOver }

class GameController extends ChangeNotifier {
  Snake _snake = Snake(
    body: const [Position(x: 10, y: 10), Position(x: 9, y: 10), Position(x: 8, y: 10)],
    direction: Direction.right,
  );

  Position? _food;
  int _score = 0;
  int _highScore = 0;
  bool _isNewHighScore = false;
  GameState _gameState = GameState.ready;
  Timer? _gameTimer;
  late HighScoreService _highScoreService;

  Snake get snake => _snake;
  Position? get food => _food;
  int get score => _score;
  int get highScore => _highScore;
  bool get isNewHighScore => _isNewHighScore;
  GameState get gameState => _gameState;
  bool get isGameRunning => _gameState == GameState.running;

  Future<void> initialize() async {
    _highScoreService = await HighScoreService.getInstance();
    _highScore = _highScoreService.getHighScore();
    notifyListeners();
  }

  void startGame() {
    _resetGame();
    _generateFood();
    _gameState = GameState.running;
    _startGameLoop();
    notifyListeners();
  }

  void pauseGame() {
    if (_gameState == GameState.running) {
      _gameState = GameState.paused;
      _gameTimer?.cancel();
      notifyListeners();
    }
  }

  void resumeGame() {
    if (_gameState == GameState.paused) {
      _gameState = GameState.running;
      _startGameLoop();
      notifyListeners();
    }
  }

  void restartGame() {
    startGame();
  }

  void changeDirection(Direction direction) {
    if (_gameState == GameState.running) {
      _snake = _snake.changeDirection(direction);
    }
  }

  void _startGameLoop() {
    _gameTimer = Timer.periodic(GameSettings.defaultGameSpeed, (timer) {
      _updateGame();
    });
  }

  void _updateGame() {
    if (_gameState != GameState.running) return;

    final nextHeadPosition = _getNextHeadPosition();
    if (_food != null && nextHeadPosition == _food) {
      _snake = _snake.grow();
      _score += GameSettings.pointsPerFood;

      if (_score > _highScore) {
        _highScore = _score;
        _isNewHighScore = true;
      }

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

    if (head.x < 0 ||
        head.x >= GameSettings.defaultBoardSize ||
        head.y < 0 ||
        head.y >= GameSettings.defaultBoardSize) {
      return true;
    }

    return _snake.checkSelfCollision();
  }

  void _generateFood() {
    final random = Random();
    Position newFood;

    do {
      newFood = Position(
        x: random.nextInt(GameSettings.defaultBoardSize),
        y: random.nextInt(GameSettings.defaultBoardSize),
      );
    } while (_snake.body.contains(newFood));

    _food = newFood;
  }

  Future<void> _gameOver() async {
    _gameState = GameState.gameOver;
    _gameTimer?.cancel();

    await _highScoreService.incrementGamesPlayed();
    await _highScoreService.addToTotalScore(_score);
    await _highScoreService.setHighScore(_score);

    notifyListeners();
  }

  void _resetGame() {
    _snake = Snake(
      body: const [Position(x: 10, y: 10), Position(x: 9, y: 10), Position(x: 8, y: 10)],
      direction: Direction.right,
    );
    _food = null;
    _score = 0;
    _isNewHighScore = false;
    _gameTimer?.cancel();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}
