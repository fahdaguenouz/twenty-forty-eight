# Twenty Forty Eight (2048)

A Flutter implementation of the classic 2048 game! 
This project was developed based on specific functional requirements designed to mimic the original game logic and user experience before its official 2014 release.

## Features

- **4x4 Grid**: The classic game board.
- **Swipe Controls**: Swipe up, down, left, or right to move tiles.
- **Tile Merging**: Matching tiles merge into a single tile with double the value.
- **Score Tracking**: Keep track of your current score and your all-time best score.
- **Smooth Animations**: Tiles slide and merge with fluid animations.
- **Restart Game**: Easily restart the game when no moves are left or at any point.

## Project Structure (Refactored)

The project separates UI logic from game logic for better maintainability:
- `lib/main.dart`: The entry point of the app.
- `lib/game_board.dart`: Contains the main state management and game grid logic.
- `lib/models/tile.dart`: The data model representing a single tile on the board.
- `lib/widgets/`: Extracted UI components for the score board, tile visual, and game over screen.
- `lib/utils/game_colors.dart`: Contains functions to determine tile colors based on their value.

## Getting Started

To get started with this project, you need to have Flutter installed on your machine.
Follow the [official Flutter installation guide](https://docs.flutter.dev/get-started/install) if you haven't already.

### Commands

**Run the app:**
