import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  final String level;
  final String scenario;

  const QuizScreen({
    super.key,
    required this.level,
    required this.scenario,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz")),
      body: Center(
        child: Text(
          "Quiz for $scenario ($level)",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}