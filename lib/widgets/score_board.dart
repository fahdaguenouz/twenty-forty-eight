import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  final String label;
  final int score;

  const ScoreBoard({
    super.key,
    required this.label,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Text(
            label,
