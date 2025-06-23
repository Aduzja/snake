import 'package:flutter/material.dart';
import 'package:snake/screens/game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'SNAKE',
              style: TextStyle(fontSize: 48, color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'GAME',
              style: TextStyle(fontSize: 48, color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const GameScreen()));
              },
              child: const Text('START GAME'),
            ),
          ],
        ),
      ),
    );
  }
}
