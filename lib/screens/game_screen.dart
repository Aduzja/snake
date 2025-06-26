
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake/controllers/game_controller.dart';
import 'package:snake/models/direction.dart'; 
import 'package:snake/utilis/constants.dart';
import 'package:snake/widgets/game_board.dart';
import 'package:snake/widgets/game_over_dialog.dart';
  
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameController _gameController;
  final FocusNode _focusNode = FocusNode();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _gameController = GameController();
    _gameController.addListener(_onGameStateChanged);
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    await _gameController.initialize();
    setState(() {
      _isInitialized = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _gameController.removeListener(_onGameStateChanged);
    _gameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onGameStateChanged() {
    setState(() {});

    if (_gameController.gameState == GameState.gameOver) {
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameOverDialog(
        score: _gameController.score,
        isNewHighScore: _gameController.isNewHighScore,
        onRestart: () {
          Navigator.of(context).pop();
          _gameController.restartGame();
          _focusNode.requestFocus();
        },
        onHome: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop(true);
        },
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
        case LogicalKeyboardKey.keyW:
          _gameController.changeDirection(Direction.up);
          break;
        case LogicalKeyboardKey.arrowDown:
        case LogicalKeyboardKey.keyS:
          _gameController.changeDirection(Direction.down);
          break;
        case LogicalKeyboardKey.arrowLeft:
        case LogicalKeyboardKey.keyA:
          _gameController.changeDirection(Direction.left);
          break;
        case LogicalKeyboardKey.arrowRight:
        case LogicalKeyboardKey.keyD:
          _gameController.changeDirection(Direction.right);
          break;
        case LogicalKeyboardKey.space:
          if (_gameController.gameState == GameState.running) {
            _gameController.pauseGame();
          } else if (_gameController.gameState == GameState.paused) {
            _gameController.resumeGame();
          } else if (_gameController.gameState == GameState.ready) {
            _gameController.startGame();
          }
          break;
      }
    }
  }

  IconData _getAppBarIcon() {
    switch (_gameController.gameState) {
      case GameState.running:
        return Icons.pause;
      case GameState.paused:
        return Icons.play_arrow;
      case GameState.ready:
      case GameState.gameOver:
        return Icons.play_arrow;
    }
  }

  void _handleAppBarAction() {
    switch (_gameController.gameState) {
      case GameState.running:
        _gameController.pauseGame();
        break;
      case GameState.paused:
        _gameController.resumeGame();
        break;
      case GameState.ready:
      case GameState.gameOver:
        _gameController.startGame();
        break;
    }
    _focusNode.requestFocus();
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
          const SizedBox(height: 8),
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

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: GameColors.background,
        body: Center(child: CircularProgressIndicator(color: GameColors.snakeHead)),
      );
    }

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: GameColors.background,
        appBar: AppBar(
          title: Row(
            children: [
              Text('Score: ${_gameController.score}'),
              const Spacer(),
              if (_gameController.highScore > 0)
                Text('Best: ${_gameController.highScore}', style: const TextStyle(color: Colors.amber, fontSize: 14)),
            ],
          ),
          actions: [IconButton(icon: Icon(_getAppBarIcon()), onPressed: _handleAppBarAction)],
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
                      child: GameBoard(snake: _gameController.snake, food: _gameController.food),
                    ),
                    if (_gameController.gameState == GameState.paused)
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
                    if (_gameController.gameState == GameState.ready)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(204, 0, 0, 0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('Press Space to Start', style: TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                  ],
                ),
              ),
            ),
            _buildControls(),
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
    );
  }
}
