import 'package:flutter/material.dart';

/// A single cell on the grid or piece display.
class BlockCell extends StatelessWidget {
  final Color? color;
  final double size;
  final bool isHighlight;
  final bool isInvalid;

  const BlockCell({
    super.key,
    this.color,
    required this.size,
    this.isHighlight = false,
    this.isInvalid = false,
  });

  @override
  Widget build(BuildContext context) {
    final cellColor = color;
    final isEmpty = cellColor == null && !isHighlight && !isInvalid;

    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isEmpty
            ? const Color(0xFF1A1A2E)
            : isInvalid
                ? Colors.red.withValues(alpha: 0.3)
                : isHighlight
                    ? (cellColor ?? Colors.white).withValues(alpha: 0.4)
                    : cellColor,
        border: isEmpty
            ? Border.all(color: const Color(0xFF2A2A4A), width: 0.5)
            : null,
        boxShadow: cellColor != null && !isEmpty
            ? [
                BoxShadow(
                  color: cellColor.withValues(alpha: 0.4),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ]
            : null,
        gradient: cellColor != null && !isEmpty && !isHighlight
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(cellColor, Colors.white, 0.3)!,
                  cellColor,
                  Color.lerp(cellColor, Colors.black, 0.2)!,
                ],
              )
            : null,
      ),
    );
  }
}
