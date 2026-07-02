import 'package:flutter/material.dart';

import '../models/piece.dart';
import 'block_cell.dart';

/// A piece that can be dragged onto the grid.
class DraggablePiece extends StatelessWidget {
  final Piece piece;
  final int index;
  final double cellSize;
  final VoidCallback onDragStarted;
  final VoidCallback onDragEnd;

  const DraggablePiece({
    super.key,
    required this.piece,
    required this.index,
    required this.cellSize,
    required this.onDragStarted,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    final pieceWidget = _buildPieceWidget(cellSize * 0.7);
    final dragWidget = _buildPieceWidget(cellSize);

    return Draggable<int>(
      data: index,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.translate(
          offset: Offset(
            -(piece.width * cellSize) / 2,
            -(piece.height * cellSize) - 40,
          ),
          child: Opacity(
            opacity: 0.85,
            child: dragWidget,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.2,
        child: pieceWidget,
      ),
      onDragStarted: onDragStarted,
      onDragEnd: (_) => onDragEnd(),
      child: pieceWidget,
    );
  }

  Widget _buildPieceWidget(double size) {
    final maxRow = piece.shape.map((o) => o.dy.toInt()).reduce((a, b) => a > b ? a : b);
    final maxCol = piece.shape.map((o) => o.dx.toInt()).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      width: (maxCol + 1) * (size + 2),
      height: (maxRow + 1) * (size + 2),
      child: Stack(
        children: piece.shape.map((offset) {
          return Positioned(
            left: offset.dx * (size + 2),
            top: offset.dy * (size + 2),
            child: BlockCell(
              size: size,
              color: piece.color,
            ),
          );
        }).toList(),
      ),
    );
  }
}
