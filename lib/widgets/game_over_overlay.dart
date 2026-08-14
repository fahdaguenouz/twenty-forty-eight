import 'package:flutter/material.dart';

class GameOverOverlay extends StatelessWidget {
  final VoidCallback onRestart;

  const GameOverOverlay({
    super.key,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
