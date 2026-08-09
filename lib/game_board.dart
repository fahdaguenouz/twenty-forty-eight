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
  }

  void _spawnTile() {
    List<Point<int>> emptyCells = [];
    for (int x = 0; x < _gridSize; x++) {
      for (int y = 0; y < _gridSize; y++) {
        if (!_tiles.any((t) => t.x == x && t.y == y)) {
          emptyCells.add(Point(x, y));
        }
      }
    }
    if (emptyCells.isEmpty) return;

    final randomCell = emptyCells[Random().nextInt(emptyCells.length)];
    final value = Random().nextDouble() < 0.9 ? 2 : 4; //90% → 2, 10% → 4
    _tiles.add(
      Tile(
        id: _uuid.v4(),
        value: value,
        x: randomCell.x,
        y: randomCell.y,
        isNew: true,
      ),
    );
  }

  void _handleSwipe(SwipeDirection direction) {
    if (_gameOver || _isMoving) return;

    _isMoving = true;

    // Remove old animation flags.
    final oldTiles = _tiles
        .map((tile) => tile.copyWith(isMerged: false, isNew: false))
        .toList();

    final List<Tile> newTiles = [];
    int scoreToAdd = 0;

    // Process each row or column independently.
    for (int line = 0; line < _gridSize; line++) {
      List<Tile> lineTiles;

      if (direction == SwipeDirection.left ||
          direction == SwipeDirection.right) {
        // Get tiles from this row.
        lineTiles = oldTiles.where((tile) => tile.y == line).toList();

        // Sort in the direction of movement.
        lineTiles.sort((a, b) {
          if (direction == SwipeDirection.left) {
            return a.x.compareTo(b.x);
          } else {
            return b.x.compareTo(a.x);
          }
        });
      } else {
        // Get tiles from this column.
        lineTiles = oldTiles.where((tile) => tile.x == line).toList();

        // Sort in the direction of movement.
        lineTiles.sort((a, b) {
          if (direction == SwipeDirection.up) {
            return a.y.compareTo(b.y);
