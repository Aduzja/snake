import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Snake Game'), backgroundColor: Colors.green),
      body: const Center(
        child: Text('Game Area', style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );
  }
}
