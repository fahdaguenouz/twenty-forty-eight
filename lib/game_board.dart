import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'models/tile.dart';
import 'widgets/score_board.dart';
import 'widgets/tile_widget.dart';
import 'widgets/game_over_overlay.dart';

enum SwipeDirection { up, down, left, right }

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<Tile> _tiles = [];
  int _score = 0;
  int _bestScore = 0;
  bool _gameOver = false;
  final int _gridSize = 4;
  final _uuid = const Uuid();
  bool _isMoving = false;
  Offset? _dragStart;
  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    setState(() {
      _tiles.clear();
      _score = 0;
      _gameOver = false;
      int initialTiles = Random().nextInt(2) + 3; // 3 or 4
      for (int i = 0; i < initialTiles; i++) {
        _spawnTile();
      }
    });
