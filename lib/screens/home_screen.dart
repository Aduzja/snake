import 'package:flutter/material.dart';
import 'package:snake/screens/game_screen.dart';
import 'package:snake/screens/statistics_screen.dart';
import 'package:snake/services/high_score_service.dart';
import 'package:snake/utilis/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _highScore = 0;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final service = await HighScoreService.getInstance();
    setState(() {
      _highScore = service.getHighScore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [GameColors.background, GameColors.board],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🐍', style: TextStyle(fontSize: 80)),
                      const SizedBox(height: 20),
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            LinearGradient(colors: [GameColors.snakeHead, GameColors.accent]).createShader(bounds),
                        child: const Text(
                          'SNAKE',
                          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const Text(
                        'GAME',
                        style: TextStyle(fontSize: 48, color: GameColors.text, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),
                      if (_highScore > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: GameColors.board.withAlpha((0.8 * 255).round()),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.amber.withAlpha((0.5 * 255).round())),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'High Score: $_highScore',
                                style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 50),
                      _buildMenuButton(
                        text: 'START GAME',
                        icon: Icons.play_arrow,
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const GameScreen()),
                          );
                          if (result == true) {
                            _loadHighScore();
                          }
                        },
                        isPrimary: true,
                      ),
                      const SizedBox(height: 16),
                      _buildMenuButton(
                        text: 'STATISTICS',
                        icon: Icons.bar_chart,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const StatisticsScreen()));
                        },
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Use Arrow Keys or WASD to control\nSpace to pause',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? GameColors.snakeHead : GameColors.board,
          foregroundColor: isPrimary ? Colors.white : GameColors.text,
          side: isPrimary ? null : BorderSide(color: GameColors.snakeHead.withAlpha((0.5 * 255).round())),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon), const SizedBox(width: 12), Text(text)],
        ),
      ),
    );
  }
}
