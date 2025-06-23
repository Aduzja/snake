import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 20, childAspectRatio: 1),
            itemBuilder: (_, index) => Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!)),
            ),
          ),
        ),
      ),
    );
  }
}
