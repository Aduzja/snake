import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake/presentation/cubit/game_state.dart';
import 'package:snake/models/difficulty.dart';
import 'package:snake/models/direction.dart';
import 'package:snake/models/position.dart';
import 'package:snake/models/snake.dart';
import 'package:snake/services/high_score_service.dart';
import 'package:snake/utilis/constants.dart';

class GameCubit extends Cubit<GameState> {
  Timer? _gameTimer;
  late HighScoreService _highScoreService;

  GameCubit() : super(GameState.initial());

  Future<void> initialize() async {
    _highScoreService = await HighScoreService.getInstance();
    final highScore = _highScoreService.getHighScore();
    final gamesPlayed = _highScoreService.getGamesPlayed();
    final totalScore = _highScoreService.getTotalScore();
    final averageScore = _highScoreService.getAverageScore();
    emit(
      state.copyWith(
        highScore: highScore,
        gamesPlayed: gamesPlayed,
        totalScore: totalScore,
        averageScore: averageScore,
      ),
    );
  }

  void startGame() {
    _resetGame();
    _generateFood();
    emit(state.copyWith(status: GameStatus.running));
    _startGameLoop();
  }

  void pauseGame() {
    if (state.status == GameStatus.running) {
      emit(state.copyWith(status: GameStatus.paused));
      _gameTimer?.cancel();
    }
  }

  void resumeGame() {
    if (state.status == GameStatus.paused) {
      emit(state.copyWith(status: GameStatus.running));
      _startGameLoop();
    }
  }

  void restartGame() {
    startGame();
  }

  void changeDirection(Direction direction) {
    if (state.status == GameStatus.running) {
      final newSnake = state.snake.changeDirection(direction);
      emit(state.copyWith(snake: newSnake));
    }
  }

  void _startGameLoop() {
    _gameTimer = Timer.periodic(state.difficulty.speed, (timer) {
      _updateGame();
    });
  }

  void _updateGame() {
    if (state.status != GameStatus.running) return;

    final nextHeadPosition = _getNextHeadPosition();
    Snake newSnake;
    int newScore = state.score;
    bool newHighScoreFlag = state.isNewHighScore;

    if (state.food != null && nextHeadPosition == state.food) {
      newSnake = state.snake.grow();
      newScore += GameSettings.pointsPerFood * state.difficulty.pointsMultiplier;

      if (newScore > state.highScore) {
        newHighScoreFlag = true;
      }

      emit(
        state.copyWith(
          snake: newSnake,
          score: newScore,
          highScore: newScore > state.highScore ? newScore : state.highScore,
          isNewHighScore: newHighScoreFlag,
        ),
      );
      _generateFood();
    } else {
      newSnake = state.snake.move();
      emit(state.copyWith(snake: newSnake));
    }

    if (_checkCollisions()) {
      _gameOver();
      return;
    }
  }

  Position _getNextHeadPosition() {
    final currentHead = state.snake.head;

    switch (state.snake.direction) {
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
    final head = state.snake.head;

    if (head.x < 0 ||
        head.x >= GameSettings.defaultBoardSize ||
        head.y < 0 ||
        head.y >= GameSettings.defaultBoardSize) {
      return true;
    }

    return state.snake.checkSelfCollision();
  }

  void _generateFood() {
    final random = Random();
    Position newFood;

    do {
      newFood = Position(
        x: random.nextInt(GameSettings.defaultBoardSize),
        y: random.nextInt(GameSettings.defaultBoardSize),
      );
    } while (state.snake.body.contains(newFood));

    emit(state.copyWith(food: newFood));
  }

  Future<void> _gameOver() async {
    emit(state.copyWith(status: GameStatus.gameOver));
    _gameTimer?.cancel();

    await _highScoreService.incrementGamesPlayed();
    await _highScoreService.addToTotalScore(state.score);
    await _highScoreService.setHighScore(state.score);

    final highScore = _highScoreService.getHighScore();
    final gamesPlayed = _highScoreService.getGamesPlayed();
    final totalScore = _highScoreService.getTotalScore();
    final averageScore = _highScoreService.getAverageScore();

    emit(
      state.copyWith(
        status: GameStatus.gameOver,
        highScore: highScore,
        gamesPlayed: gamesPlayed,
        totalScore: totalScore,
        averageScore: averageScore,
      ),
    );
  }

  void _resetGame() {
    const initialSnake = Snake(
      body: [Position(x: 10, y: 10), Position(x: 9, y: 10), Position(x: 8, y: 10)],
      direction: Direction.right,
    );

    emit(state.copyWith(snake: initialSnake, food: null, score: 0, isNewHighScore: false));
    _gameTimer?.cancel();
  }

  Future<void> clearStats() async {
    await _highScoreService.clearStats();
    final highScore = _highScoreService.getHighScore();
    final gamesPlayed = _highScoreService.getGamesPlayed();
    final totalScore = _highScoreService.getTotalScore();
    final averageScore = _highScoreService.getAverageScore();
    emit(
      state.copyWith(
        highScore: highScore,
        gamesPlayed: gamesPlayed,
        totalScore: totalScore,
        averageScore: averageScore,
      ),
    );
  }

  void resetGameWithDifficulty(Difficulty difficulty) {
    emit(GameState.initial(difficulty: difficulty));
  }

  @override
  Future<void> close() {
    _gameTimer?.cancel();
    return super.close();
  }
}
