import 'package:flutter/material.dart';

class GameColors {
  static Color getTileColor(int value) {
    switch (value) {
      case 2:
        return Colors.orange[50]!;
      case 4:
        return Colors.orange[100]!;
      case 8:
        return Colors.orange[200]!;
      case 16:
        return Colors.orange[300]!;
      case 32:
        return Colors.orange[400]!;
      case 64:
        return Colors.orange[500]!;
      case 128:
