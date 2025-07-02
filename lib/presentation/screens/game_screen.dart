import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake/models/difficulty.dart';
import 'package:snake/models/direction.dart';
import 'package:snake/utilis/constants.dart';
import 'package:snake/presentation/widgets/game_board.dart';
import 'package:snake/presentation/widgets/game_over_dialog.dart';
import 'package:snake/presentation/widgets/swipe_detector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake/presentation/cubit/game_state.dart';
import 'package:snake/presentation/cubit/game_cubit.dart';

class GameScreen extends StatelessWidget {
  final Difficulty difficulty;

  const GameScreen({super.key, this.difficulty = Difficulty.normal});

  IconData _getAppBarIcon(GameState state) {
    switch (state.status) {
      case GameStatus.running:
        return Icons.pause;
      case GameStatus.paused:
        return Icons.play_arrow;
      case GameStatus.ready:
      case GameStatus.gameOver:
        return Icons.play_arrow;
    }
  }

  void _handleAppBarAction(BuildContext context, GameState state) {
    switch (state.status) {
      case GameStatus.running:
        context.read<GameCubit>().pauseGame();
        break;
      case GameStatus.paused:
        context.read<GameCubit>().resumeGame();
        break;
      case GameStatus.ready:
      case GameStatus.gameOver:
        context.read<GameCubit>().startGame();
        break;
    }
  }

  Widget _buildControls(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.read<GameCubit>().changeDirection(Direction.up),
            child: const Icon(Icons.keyboard_arrow_up),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => context.read<GameCubit>().changeDirection(Direction.left),
                child: const Icon(Icons.keyboard_arrow_left),
              ),
              ElevatedButton(
                onPressed: () => context.read<GameCubit>().changeDirection(Direction.down),
                child: const Icon(Icons.keyboard_arrow_down),
              ),
              ElevatedButton(
                onPressed: () => context.read<GameCubit>().changeDirection(Direction.right),
                child: const Icon(Icons.keyboard_arrow_right),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    return BlocListener<GameCubit, GameState>(
      listenWhen: (previous, current) =>
          previous.status != GameStatus.gameOver && current.status == GameStatus.gameOver,
      listener: (context, state) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => GameOverDialog(
            score: state.score,
            isNewHighScore: state.isNewHighScore,
            onRestart: () {
              Navigator.of(context).pop();
              context.read<GameCubit>().restartGame();
            },
            onHome: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            },
          ),
        );
      },
      child: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          return SwipeDetector(
            onSwipe: (direction) => context.read<GameCubit>().changeDirection(direction),
            child: KeyboardListener(
              focusNode: focusNode,
              autofocus: true,
              onKeyEvent: (event) {
                if (event is KeyDownEvent) {
                  switch (event.logicalKey) {
                    case LogicalKeyboardKey.arrowUp:
                    case LogicalKeyboardKey.keyW:
                      context.read<GameCubit>().changeDirection(Direction.up);
                      break;
                    case LogicalKeyboardKey.arrowDown:
                    case LogicalKeyboardKey.keyS:
                      context.read<GameCubit>().changeDirection(Direction.down);
                      break;
                    case LogicalKeyboardKey.arrowLeft:
                    case LogicalKeyboardKey.keyA:
                      context.read<GameCubit>().changeDirection(Direction.left);
                      break;
                    case LogicalKeyboardKey.arrowRight:
                    case LogicalKeyboardKey.keyD:
                      context.read<GameCubit>().changeDirection(Direction.right);
                      break;
                    case LogicalKeyboardKey.space:
                      if (state.status == GameStatus.running) {
                        context.read<GameCubit>().pauseGame();
                      } else if (state.status == GameStatus.paused) {
                        context.read<GameCubit>().resumeGame();
                      } else if (state.status == GameStatus.ready) {
                        context.read<GameCubit>().startGame();
                      }
                      break;
                  }
                }
              },
              child: Scaffold(
                backgroundColor: GameColors.background,
                appBar: AppBar(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Score: ${state.score}'),
                          const Spacer(),
                          if (state.highScore > 0)
                            Text('Best: ${state.highScore}', style: const TextStyle(color: Colors.amber, fontSize: 14)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(difficulty.icon, color: difficulty.color, size: 16),
                          const SizedBox(width: 4),
                          Text(difficulty.name, style: TextStyle(color: difficulty.color, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(icon: Icon(_getAppBarIcon(state)), onPressed: () => _handleAppBarAction(context, state)),
                  ],
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: GameBoard(snake: state.snake, food: state.food),
                            ),
                            if (state.status == GameStatus.paused)
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(204, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'PAUSED',
                                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ),
                            if (state.status == GameStatus.ready)
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(204, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Press Space to Start',
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    _buildControls(context),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Use Arrow Keys or WASD to control, Space to pause',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
