import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake/utilis/constants.dart';
import 'package:snake/presentation/cubit/game_cubit.dart';
import 'package:snake/presentation/cubit/game_state.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  Future<void> _clearStats(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GameColors.board,
        title: const Text('Clear Statistics'),
        content: const Text('Are you sure you want to clear all statistics? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (!context.mounted) return;
    if (confirmed == true) {
      context.read<GameCubit>().clearStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Statistics'),
            actions: [IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _clearStats(context))],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [GameColors.background, GameColors.board],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildStatCard(
                    title: 'High Score',
                    value: state.highScore.toString(),
                    icon: Icons.emoji_events,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard(
                    title: 'Games Played',
                    value: state.gamesPlayed?.toString() ?? '-',
                    icon: Icons.sports_esports,
                    color: GameColors.snakeHead,
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard(
                    title: 'Total Score',
                    value: state.totalScore?.toString() ?? '-',
                    icon: Icons.score,
                    color: GameColors.accent,
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard(
                    title: 'Average Score',
                    value: state.averageScore?.toStringAsFixed(1) ?? '-',
                    icon: Icons.trending_up,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GameColors.board,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromARGB(77, 76, 175, 80)),
        boxShadow: const [BoxShadow(color: Color.fromARGB(26, 255, 193, 7), blurRadius: 8, spreadRadius: 2)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(51, 76, 175, 80),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
