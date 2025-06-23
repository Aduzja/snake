import 'package:flutter/material.dart';
import 'package:snake/controllers/game_controller.dart';
import 'package:snake/models/direction.dart';
import 'package:snake/widgets/game_board.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameController _gameController;

  @override
  void initState() {
    super.initState();
    _gameController = GameController();
    _gameController.addListener(_onGameStateChanged);
  }

  @override
  void dispose() {
    _gameController.removeListener(_onGameStateChanged);
    _gameController.dispose();
    super.dispose();
  }

  void _onGameStateChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Score: ${_gameController.score}'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(_gameController.isGameRunning ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              if (_gameController.isGameRunning) {
                _gameController.pauseGame();
              } else {
                _gameController.startGame();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GameBoard(snake: _gameController.snake, food: _gameController.food),
              ),
            ),
          ),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => _gameController.changeDirection(Direction.up),
            child: const Icon(Icons.keyboard_arrow_up),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _gameController.changeDirection(Direction.left),
                child: const Icon(Icons.keyboard_arrow_left),
              ),
              ElevatedButton(
                onPressed: () => _gameController.changeDirection(Direction.down),
                child: const Icon(Icons.keyboard_arrow_down),
              ),
              ElevatedButton(
                onPressed: () => _gameController.changeDirection(Direction.right),
                child: const Icon(Icons.keyboard_arrow_right),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
