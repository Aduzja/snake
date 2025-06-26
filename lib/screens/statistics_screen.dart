import 'package:flutter/material.dart';
import 'package:snake/services/high_score_service.dart';
import 'package:snake/utilis/constants.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late HighScoreService _highScoreService;
  bool _isLoading = true;

  int _highScore = 0;
  int _gamesPlayed = 0;
  int _totalScore = 0;
  double _averageScore = 0.0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    _highScoreService = await HighScoreService.getInstance();
    setState(() {
      _highScore = _highScoreService.getHighScore();
      _gamesPlayed = _highScoreService.getGamesPlayed();
      _totalScore = _highScoreService.getTotalScore();
      _averageScore = _highScoreService.getAverageScore();
      _isLoading = false;
    });
  }

  Future<void> _clearStats() async {
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

    if (confirmed == true) {
      await _highScoreService.clearStats();
      _loadStats();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [IconButton(icon: const Icon(Icons.delete_outline), onPressed: _clearStats)],
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
                value: _highScore.toString(),
                icon: Icons.emoji_events,
                color: Colors.amber,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                title: 'Games Played',
                value: _gamesPlayed.toString(),
                icon: Icons.sports_esports,
                color: GameColors.snakeHead,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                title: 'Total Score',
                value: _totalScore.toString(),
                icon: Icons.score,
                color: GameColors.accent,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                title: 'Average Score',
                value: _averageScore.toStringAsFixed(1),
                icon: Icons.trending_up,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GameColors.board,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color.fromARGB(77, 76, 175, 80)),
        boxShadow: [BoxShadow(color: Color.fromARGB(26, 255, 193, 7), blurRadius: 8, spreadRadius: 2)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Color.fromARGB(51, 76, 175, 80), borderRadius: BorderRadius.circular(8)),
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
