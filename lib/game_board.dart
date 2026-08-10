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
          } else {
            return b.y.compareTo(a.y);
          }
        });
      }

      // Merge tiles in this row/column.
      List<Tile> mergedLine = [];

      int i = 0;

      while (i < lineTiles.length) {
        Tile current = lineTiles[i];

        // Check if the next tile can merge.
        if (i + 1 < lineTiles.length &&
            lineTiles[i + 1].value == current.value) {
          Tile next = lineTiles[i + 1];

          final mergedValue = current.value * 2;

          // Keep the first tile's ID.
          // This allows AnimatedPositioned to animate it smoothly.
          final mergedTile = current.copyWith(
            value: mergedValue,
            isMerged: true,
            isNew: false,
          );

          mergedLine.add(mergedTile);

          scoreToAdd += mergedValue;

          i += 2;
        } else {
          mergedLine.add(current);
          i++;
        }
      }

      // Put the resulting tiles at their final positions.
      for (int index = 0; index < mergedLine.length; index++) {
        Tile tile = mergedLine[index];

        int newX = tile.x;
        int newY = tile.y;

        if (direction == SwipeDirection.left) {
          newX = index;
        } else if (direction == SwipeDirection.right) {
          newX = _gridSize - 1 - index;
        } else if (direction == SwipeDirection.up) {
          newY = index;
        } else if (direction == SwipeDirection.down) {
          newY = _gridSize - 1 - index;
        }

        newTiles.add(tile.copyWith(x: newX, y: newY));
      }
    }

    // Check whether anything actually changed.
    final bool moved = !_sameBoard(oldTiles, newTiles);

    if (!moved) {
      _isMoving = false;
      return;
    }

    // Update score.
    _score += scoreToAdd;

    if (_score > _bestScore) {
      _bestScore = _score;
    }

    // Update the board so AnimatedPositioned can animate the movement.
    setState(() {
      _tiles = newTiles;
    });

    // Wait for the movement animation to finish.
    Future.delayed(const Duration(milliseconds: 150), () {
      if (!mounted) return;

      _spawnTile();

      _checkGameOver();

      setState(() {
        _isMoving = false;
      });
    });
  }

  bool _sameBoard(List<Tile> oldTiles, List<Tile> newTiles) {
    if (oldTiles.length != newTiles.length) {
      return false;
    }

    for (final oldTile in oldTiles) {
      final match = newTiles.where((tile) => tile.id == oldTile.id);

      if (match.isEmpty) {
        return false;
      }

      final newTile = match.first;

      if (oldTile.x != newTile.x ||
          oldTile.y != newTile.y ||
          oldTile.value != newTile.value) {
