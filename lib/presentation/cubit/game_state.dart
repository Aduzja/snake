import 'package:equatable/equatable.dart';
import 'package:snake/models/direction.dart';
import 'package:snake/models/position.dart';
import 'package:snake/models/snake.dart';
import 'package:snake/models/difficulty.dart';

enum GameStatus { ready, running, paused, gameOver }

class GameState extends Equatable {
  final Snake snake;
  final Position? food;
  final int score;
  final int highScore;
  final bool isNewHighScore;
  final GameStatus status;
  final int? gamesPlayed;
  final int? totalScore;
  final double? averageScore;
  final Difficulty difficulty;

  const GameState({
    required this.snake,
    this.food,
    required this.score,
    required this.highScore,
    required this.isNewHighScore,
    required this.status,
    this.gamesPlayed,
    this.totalScore,
    this.averageScore,
    required this.difficulty,
  });

  factory GameState.initial({Difficulty difficulty = Difficulty.normal}) {
    return GameState(
      snake: const Snake(
        body: [Position(x: 10, y: 10), Position(x: 9, y: 10), Position(x: 8, y: 10)],
        direction: Direction.right,
      ),
      food: null,
      score: 0,
      highScore: 0,
      isNewHighScore: false,
      status: GameStatus.ready,
      gamesPlayed: null,
      totalScore: null,
      averageScore: null,
      difficulty: difficulty,
    );
  }

  GameState copyWith({
    Snake? snake,
    Position? food,
    int? score,
    int? highScore,
    bool? isNewHighScore,
    GameStatus? status,
    int? gamesPlayed,
    int? totalScore,
    double? averageScore,
    Difficulty? difficulty,
  }) {
    return GameState(
      snake: snake ?? this.snake,
      food: food ?? this.food,
      score: score ?? this.score,
      highScore: highScore ?? this.highScore,
      isNewHighScore: isNewHighScore ?? this.isNewHighScore,
      status: status ?? this.status,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      totalScore: totalScore ?? this.totalScore,
      averageScore: averageScore ?? this.averageScore,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  bool get isGameRunning => status == GameStatus.running;

  @override
  List<Object?> get props => [
    snake,
    food,
    score,
    highScore,
    isNewHighScore,
    status,
    gamesPlayed,
    totalScore,
    averageScore,
    difficulty,
  ];
}
