import 'package:flutter/material.dart';
import 'package:snake/models/difficulty.dart';
import 'package:snake/screens/game_screen.dart';
import 'package:snake/utilis/constants.dart';

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Difficulty')),
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
                const SizedBox(height: 20),
                const Text(
                  'Select Difficulty Level',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: GameColors.text),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemCount: Difficulty.values.length,
                    itemBuilder: (context, index) {
                      final difficulty = Difficulty.values[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildDifficultyCard(context, difficulty),
                      );
                    },
                  ),
                ),
                const Text(
                  'Higher difficulty = More points per food!',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyCard(BuildContext context, Difficulty difficulty) {
    return Container(
      decoration: BoxDecoration(
        color: GameColors.board,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color.fromARGB(77, difficulty.color.red, difficulty.color.green, difficulty.color.blue),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(26, difficulty.color.red, difficulty.color.green, difficulty.color.blue),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => GameScreen()));
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(51, difficulty.color.red, difficulty.color.green, difficulty.color.blue),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(difficulty.icon, color: difficulty.color, size: 32),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        difficulty.name,
                        style: TextStyle(color: difficulty.color, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Speed: ${_getSpeedDescription(difficulty)}',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Text(
                        'Points: ${difficulty.pointsMultiplier}x multiplier',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: difficulty.color, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getSpeedDescription(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 'Slow and steady';
      case Difficulty.normal:
        return 'Just right';
      case Difficulty.hard:
        return 'Fast-paced';
      case Difficulty.extreme:
        return 'Lightning fast!';
    }
  }
}
