import 'package:flutter/material.dart';

import '../models/piece.dart';
import 'draggable_piece.dart';

/// Displays the 3 available pieces at the bottom.
class PieceTray extends StatelessWidget {
  final List<Piece?> pieces;
  final double cellSize;
  final Function(int index, Piece piece) onDragStarted;
  final VoidCallback onDragEnd;

  const PieceTray({
    super.key,
    required this.pieces,
    required this.cellSize,
    required this.onDragStarted,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F23),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A4A), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          final piece = index < pieces.length ? pieces[index] : null;
          if (piece == null) {
            return SizedBox(
              width: cellSize * 5 + 10,
              height: cellSize * 5 + 10,
            );
          }
          return DraggablePiece(
            piece: piece,
            index: index,
            cellSize: cellSize,
            onDragStarted: () => onDragStarted(index, piece),
            onDragEnd: onDragEnd,
          );
        }),
      ),
    );
  }
}
