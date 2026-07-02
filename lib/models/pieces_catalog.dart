import 'dart:ui';

/// All available piece templates used in the game.
class PiecesCatalog {
  static const List<Color> pieceColors = [
    Color(0xFFFF6B6B), // red
    Color(0xFF4ECDC4), // teal
    Color(0xFFFFE66D), // yellow
    Color(0xFF95E1D3), // mint
    Color(0xFFFF8A5C), // orange
    Color(0xFF6C5CE7), // purple
    Color(0xFF74B9FF), // blue
    Color(0xFFFD79A8), // pink
    Color(0xFF00CEC9), // cyan
    Color(0xFFA29BFE), // lavender
  ];

  static final List<List<Offset>> shapes = [
    // 1x1 dot
    [const Offset(0, 0)],

    // 1x2 horizontal
    [const Offset(0, 0), const Offset(1, 0)],

    // 1x3 horizontal
    [const Offset(0, 0), const Offset(1, 0), const Offset(2, 0)],

    // 1x4 horizontal
    [const Offset(0, 0), const Offset(1, 0), const Offset(2, 0), const Offset(3, 0)],

    // 1x5 horizontal
    [const Offset(0, 0), const Offset(1, 0), const Offset(2, 0), const Offset(3, 0), const Offset(4, 0)],

    // 2x1 vertical
    [const Offset(0, 0), const Offset(0, 1)],

    // 3x1 vertical
    [const Offset(0, 0), const Offset(0, 1), const Offset(0, 2)],

    // 4x1 vertical
    [const Offset(0, 0), const Offset(0, 1), const Offset(0, 2), const Offset(0, 3)],

    // 5x1 vertical
    [const Offset(0, 0), const Offset(0, 1), const Offset(0, 2), const Offset(0, 3), const Offset(0, 4)],

    // 2x2 square
    [const Offset(0, 0), const Offset(1, 0), const Offset(0, 1), const Offset(1, 1)],

    // 3x3 square
    [
      const Offset(0, 0), const Offset(1, 0), const Offset(2, 0),
      const Offset(0, 1), const Offset(1, 1), const Offset(2, 1),
      const Offset(0, 2), const Offset(1, 2), const Offset(2, 2),
    ],

    // L-shape (bottom-left)
    [const Offset(0, 0), const Offset(0, 1), const Offset(0, 2), const Offset(1, 2)],

    // L-shape (bottom-right)
    [const Offset(1, 0), const Offset(1, 1), const Offset(1, 2), const Offset(0, 2)],

    // L-shape (top-left)
    [const Offset(0, 0), const Offset(1, 0), const Offset(1, 1), const Offset(1, 2)],

    // L-shape (top-right)
    [const Offset(0, 0), const Offset(1, 0), const Offset(0, 1), const Offset(0, 2)],

    // T-shape down
    [const Offset(0, 0), const Offset(1, 0), const Offset(2, 0), const Offset(1, 1)],

    // T-shape up
    [const Offset(1, 0), const Offset(0, 1), const Offset(1, 1), const Offset(2, 1)],

    // T-shape right
    [const Offset(0, 0), const Offset(0, 1), const Offset(1, 1), const Offset(0, 2)],

    // T-shape left
    [const Offset(1, 0), const Offset(0, 1), const Offset(1, 1), const Offset(1, 2)],

    // S-shape
    [const Offset(1, 0), const Offset(2, 0), const Offset(0, 1), const Offset(1, 1)],

    // Z-shape
    [const Offset(0, 0), const Offset(1, 0), const Offset(1, 1), const Offset(2, 1)],

    // Big L (3x3 corner)
    [
      const Offset(0, 0), const Offset(0, 1), const Offset(0, 2),
      const Offset(1, 2), const Offset(2, 2),
    ],

    // Big L rotated
    [
      const Offset(0, 0), const Offset(1, 0), const Offset(2, 0),
      const Offset(2, 1), const Offset(2, 2),
    ],

    // 2x3 rectangle
    [
      const Offset(0, 0), const Offset(1, 0),
      const Offset(0, 1), const Offset(1, 1),
      const Offset(0, 2), const Offset(1, 2),
    ],

    // 3x2 rectangle
    [
      const Offset(0, 0), const Offset(1, 0), const Offset(2, 0),
      const Offset(0, 1), const Offset(1, 1), const Offset(2, 1),
    ],
  ];

  PiecesCatalog._();
}
