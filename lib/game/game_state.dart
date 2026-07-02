import 'dart:math';
import 'dart:ui';

import '../models/piece.dart';
import '../models/pieces_catalog.dart';

/// The 8x8 grid cell.
class Cell {
  Color? color;
  bool get isEmpty => color == null;
}

/// Core game state and logic.
class GameState {
  static const int gridSize = 8;

  final List<List<Cell>> grid;
  List<Piece?> availablePieces;
  int score;
  int highScore;
  int combo;
  bool isGameOver;

  final Random _random = Random();

  GameState()
      : grid = List.generate(gridSize, (_) => List.generate(gridSize, (_) => Cell())),
        availablePieces = [],
        score = 0,
        highScore = 0,
        combo = 0,
        isGameOver = false;

  void startNewGame() {
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        grid[r][c].color = null;
      }
    }
    score = 0;
    combo = 0;
    isGameOver = false;
    _generateNewPieces();
  }

  void _generateNewPieces() {
    availablePieces = List.generate(3, (_) => _randomPiece());
  }

  Piece _randomPiece() {
    final shapeIndex = _random.nextInt(PiecesCatalog.shapes.length);
    final colorIndex = _random.nextInt(PiecesCatalog.pieceColors.length);
    return Piece(
      shape: PiecesCatalog.shapes[shapeIndex],
      color: PiecesCatalog.pieceColors[colorIndex],
    );
  }

  /// Check if a piece can be placed at (gridRow, gridCol).
  bool canPlace(Piece piece, int gridRow, int gridCol) {
    for (final offset in piece.shape) {
      final r = gridRow + offset.dy.toInt();
      final c = gridCol + offset.dx.toInt();
      if (r < 0 || r >= gridSize || c < 0 || c >= gridSize) return false;
      if (!grid[r][c].isEmpty) return false;
    }
    return true;
  }

  /// Place a piece on the grid and return the cleared lines info.
  PlaceResult placePiece(int pieceIndex, int gridRow, int gridCol) {
    final piece = availablePieces[pieceIndex];
    if (piece == null) return PlaceResult(placed: false);
    if (!canPlace(piece, gridRow, gridCol)) return PlaceResult(placed: false);

    // Place blocks
    for (final offset in piece.shape) {
      final r = gridRow + offset.dy.toInt();
      final c = gridCol + offset.dx.toInt();
      grid[r][c].color = piece.color;
    }

    // Mark piece as used
    availablePieces[pieceIndex] = null;

    // Check for completed rows and columns
    final clearedRows = <int>[];
    final clearedCols = <int>[];

    for (int r = 0; r < gridSize; r++) {
      if (_isRowFull(r)) clearedRows.add(r);
    }
    for (int c = 0; c < gridSize; c++) {
      if (_isColFull(c)) clearedCols.add(c);
    }

    final totalCleared = clearedRows.length + clearedCols.length;

    // Update combo
    if (totalCleared > 0) {
      combo++;
    } else {
      combo = 0;
    }

    // Calculate score
    final blockPoints = piece.shape.length;
    int clearPoints = 0;
    if (totalCleared > 0) {
      clearPoints = totalCleared * gridSize * 10;
      // Combo bonus
      if (combo > 1) {
        clearPoints = (clearPoints * (1 + (combo - 1) * 0.5)).toInt();
      }
      // Multi-line bonus
      if (totalCleared > 1) {
        clearPoints = (clearPoints * 1.5).toInt();
      }
    }
    score += blockPoints + clearPoints;
    if (score > highScore) highScore = score;

    // Clear completed lines
    for (final r in clearedRows) {
      for (int c = 0; c < gridSize; c++) {
        grid[r][c].color = null;
      }
    }
    for (final c in clearedCols) {
      for (int r = 0; r < gridSize; r++) {
        grid[r][c].color = null;
      }
    }

    // If all pieces used, generate new set
    if (availablePieces.every((p) => p == null)) {
      _generateNewPieces();
    }

    // Check game over
    if (_checkGameOver()) {
      isGameOver = true;
    }

    return PlaceResult(
      placed: true,
      clearedRows: clearedRows,
      clearedCols: clearedCols,
      pointsEarned: blockPoints + clearPoints,
      combo: combo,
    );
  }

  bool _isRowFull(int row) {
    for (int c = 0; c < gridSize; c++) {
      if (grid[row][c].isEmpty) return false;
    }
    return true;
  }

  bool _isColFull(int col) {
    for (int r = 0; r < gridSize; r++) {
      if (grid[r][col].isEmpty) return false;
    }
    return true;
  }

  bool _checkGameOver() {
    for (int i = 0; i < availablePieces.length; i++) {
      final piece = availablePieces[i];
      if (piece == null) continue;
      if (_canPlaceAnywhere(piece)) return false;
    }
    return true;
  }

  bool _canPlaceAnywhere(Piece piece) {
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (canPlace(piece, r, c)) return true;
      }
    }
    return false;
  }
}

class PlaceResult {
  final bool placed;
  final List<int> clearedRows;
  final List<int> clearedCols;
  final int pointsEarned;
  final int combo;

  PlaceResult({
    required this.placed,
    this.clearedRows = const [],
    this.clearedCols = const [],
    this.pointsEarned = 0,
    this.combo = 0,
  });

  int get totalCleared => clearedRows.length + clearedCols.length;
}
