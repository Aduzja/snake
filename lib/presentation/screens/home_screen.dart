import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake/presentation/screens/difficulty_screen.dart';
import 'package:snake/presentation/screens/game_screen.dart';
import 'package:snake/presentation/screens/statistics_screen.dart';
import 'package:snake/utilis/constants.dart';
import 'package:snake/presentation/cubit/game_cubit.dart';
import 'package:snake/presentation/cubit/game_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
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
                          if (state.highScore > 0)
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
                                    'High Score: ${state.highScore}',
                                    style: const TextStyle(
                                      color: Colors.amber,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 50),
                          _buildMenuButton(
                            context: context,
                            text: 'QUICK GAME',
                            icon: Icons.flash_on,
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const GameScreen()),
                              );
                              if (!context.mounted) return;
                              if (result == true) {
                                context.read<GameCubit>().initialize();
                              }
                            },
                            isPrimary: true,
                          ),
                          const SizedBox(height: 16),
                          _buildMenuButton(
                            context: context,
                            text: 'CHOOSE DIFFICULTY',
                            icon: Icons.speed,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DifficultyScreen()),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildMenuButton(
                            context: context,
                            text: 'STATISTICS',
                            icon: Icons.bar_chart,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const StatisticsScreen()),
                              );
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
      },
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    bool isPrimary = false,
    Color? customColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: customColor ?? (isPrimary ? GameColors.snakeHead : GameColors.board),
          foregroundColor: isPrimary ? Colors.white : GameColors.text,
          side: isPrimary
              ? null
              : BorderSide(
                  color: Color.fromARGB(
                    128,
                    ((customColor ?? GameColors.snakeHead).r * 255.0).round() & 0xff,
                    ((customColor ?? GameColors.snakeHead).g * 255.0).round() & 0xff,
                    ((customColor ?? GameColors.snakeHead).b * 255.0).round() & 0xff,
                  ),
                ),
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
