import 'package:flutter/material.dart';

import '../game/game_state.dart';
import '../models/piece.dart';
import 'block_cell.dart';

/// The 8x8 game grid widget.
class GameGrid extends StatelessWidget {
  final GameState gameState;
  final double cellSize;
  final Piece? hoverPiece;
  final int? hoverRow;
  final int? hoverCol;
  final bool canPlaceHover;
  final Animation<double>? clearAnimation;
  final Set<int> clearingRows;
  final Set<int> clearingCols;

  const GameGrid({
    super.key,
    required this.gameState,
    required this.cellSize,
    this.hoverPiece,
    this.hoverRow,
    this.hoverCol,
    this.canPlaceHover = false,
    this.clearAnimation,
    this.clearingRows = const {},
    this.clearingCols = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F23),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A4A), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(GameState.gridSize, (row) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(GameState.gridSize, (col) {
              final cell = gameState.grid[row][col];
              final isHover = _isHoverCell(row, col);
              final isInvalid = isHover && !canPlaceHover;
              final isClearing = clearingRows.contains(row) ||
                  clearingCols.contains(col);

              Widget cellWidget = BlockCell(
                size: cellSize,
                color: cell.color,
                isHighlight: isHover && canPlaceHover && cell.isEmpty,
                isInvalid: isInvalid && cell.isEmpty,
              );

              if (isClearing && clearAnimation != null) {
                cellWidget = AnimatedBuilder(
                  animation: clearAnimation!,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + 0.15 * (1.0 - clearAnimation!.value),
                      child: Opacity(
                        opacity: 0.3 + 0.7 * clearAnimation!.value,
                        child: child,
                      ),
                    );
                  },
                  child: cellWidget,
                );
              }

              return cellWidget;
            }),
          );
        }),
      ),
    );
  }

  bool _isHoverCell(int row, int col) {
    if (hoverPiece == null || hoverRow == null || hoverCol == null) return false;
    for (final offset in hoverPiece!.shape) {
      final r = hoverRow! + offset.dy.toInt();
      final c = hoverCol! + offset.dx.toInt();
      if (r == row && c == col) return true;
    }
    return false;
  }
}
