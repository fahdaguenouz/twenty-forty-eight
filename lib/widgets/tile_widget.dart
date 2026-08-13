import 'package:flutter/material.dart';
import '../models/tile.dart';
import '../utils/game_colors.dart';

class TileWidget extends StatelessWidget {
  final Tile tile;
  final double tileSize;
  final double padding;

  const TileWidget({
    super.key,
    required this.tile,
    required this.tileSize,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      key: ValueKey(tile.id),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
