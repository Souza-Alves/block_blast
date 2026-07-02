import 'dart:ui';

/// A block piece that can be placed on the grid.
class Piece {
  /// Each shape is a list of (row, col) offsets from the origin (0,0).
  final List<Offset> shape;
  final Color color;

  const Piece({required this.shape, required this.color});

  int get width {
    final maxCol = shape.map((o) => o.dx.toInt()).reduce((a, b) => a > b ? a : b);
    final minCol = shape.map((o) => o.dx.toInt()).reduce((a, b) => a < b ? a : b);
    return maxCol - minCol + 1;
  }

  int get height {
    final maxRow = shape.map((o) => o.dy.toInt()).reduce((a, b) => a > b ? a : b);
    final minRow = shape.map((o) => o.dy.toInt()).reduce((a, b) => a < b ? a : b);
    return maxRow - minRow + 1;
  }
}
