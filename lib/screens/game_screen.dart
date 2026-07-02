import 'package:flutter/material.dart';

import '../game/game_state.dart';
import '../models/piece.dart';
import '../widgets/game_grid.dart';
import '../widgets/piece_tray.dart';
import '../widgets/score_display.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final GameState _gameState = GameState();

  Piece? _draggingPiece;
  int? _hoverRow;
  int? _hoverCol;
  bool _canPlaceHover = false;

  late AnimationController _clearAnimController;
  late AnimationController _scorePopController;
  int _lastPointsEarned = 0;
  bool _gameOverDialogShown = false;
  Set<int> _clearingRows = {};
  Set<int> _clearingCols = {};

  final GlobalKey _gridKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _clearAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _clearAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _clearingRows = {};
          _clearingCols = {};
        });
      }
    });
    _scorePopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _gameState.startNewGame();
  }

  @override
  void dispose() {
    _clearAnimController.dispose();
    _scorePopController.dispose();
    super.dispose();
  }

  double _getCellSize(BoxConstraints constraints) {
    final availableWidth = constraints.maxWidth - 40;
    final maxCellSize = availableWidth / (GameState.gridSize + 1);
    return maxCellSize.clamp(28.0, 44.0);
  }

  void _onDragStarted(int index, Piece piece) {
    setState(() {
      _draggingPiece = piece;
    });
  }

  void _onDragEnd() {
    setState(() {
      _draggingPiece = null;
      _hoverRow = null;
      _hoverCol = null;
      _canPlaceHover = false;
    });
  }

  void _onGridDragUpdate(DragUpdateDetails details, double cellSize) {
    if (_draggingPiece == null) return;

    final gridBox = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (gridBox == null) return;

    final localPos = gridBox.globalToLocal(details.globalPosition);
    final padding = 6.0;
    final totalCellSize = cellSize + 2;

    final col = ((localPos.dx - padding) / totalCellSize).floor();
    final row = ((localPos.dy - padding) / totalCellSize).floor();

    final feedbackOffsetY = (_draggingPiece!.height * cellSize + 40) / totalCellSize;
    final adjustedRow = row - feedbackOffsetY.round();
    final adjustedCol = col - (_draggingPiece!.width ~/ 2);

    setState(() {
      _hoverRow = adjustedRow;
      _hoverCol = adjustedCol;
      _canPlaceHover = _gameState.canPlace(_draggingPiece!, adjustedRow, adjustedCol);
    });
  }

  void _onGridDragAccept(int pieceIndex, double cellSize) {
    if (_hoverRow == null || _hoverCol == null) return;
    if (!_canPlaceHover) return;

    final result = _gameState.placePiece(pieceIndex, _hoverRow!, _hoverCol!);

    if (result.placed) {
      if (result.totalCleared > 0) {
        _clearingRows = result.clearedRows.toSet();
        _clearingCols = result.clearedCols.toSet();
        _clearAnimController.forward(from: 0);
        _lastPointsEarned = result.pointsEarned;
        _scorePopController.forward(from: 0);
      }
    }

    setState(() {
      _draggingPiece = null;
      _hoverRow = null;
      _hoverCol = null;
      _canPlaceHover = false;
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF6C5CE7), width: 2),
        ),
        title: const Text(
          'GAME OVER',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Score: ${_gameState.score}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Best: ${_gameState.highScore}',
              style: const TextStyle(
                color: Color(0xFFFFE66D),
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _gameOverDialogShown = false;
                  _gameState.startNewGame();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'PLAY AGAIN',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_gameState.isGameOver && !_gameOverDialogShown) {
      _gameOverDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGameOverDialog();
      });
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF16213E),
              Color(0xFF0F0F23),
              Color(0xFF1A1A2E),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cellSize = _getCellSize(constraints);
              final trayCellSize = cellSize * 0.55;

              return Column(
                children: [
                  const SizedBox(height: 16),

                  // Title
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF6C5CE7), Color(0xFF74B9FF), Color(0xFFA29BFE)],
                    ).createShader(bounds),
                    child: const Text(
                      'BLOCK BLAST',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Score
                  ScoreDisplay(
                    score: _gameState.score,
                    highScore: _gameState.highScore,
                    combo: _gameState.combo,
                  ),

                  const SizedBox(height: 16),

                  // Floating score animation
                  SizedBox(
                    height: 30,
                    child: AnimatedBuilder(
                      animation: _scorePopController,
                      builder: (context, child) {
                        if (_scorePopController.value == 0 || _lastPointsEarned == 0) {
                          return const SizedBox();
                        }
                        return Opacity(
                          opacity: 1 - _scorePopController.value,
                          child: Transform.translate(
                            offset: Offset(0, -20 * _scorePopController.value),
                            child: Text(
                              '+$_lastPointsEarned',
                              style: const TextStyle(
                                color: Color(0xFFFFE66D),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Grid with DragTarget
                  Expanded(
                    child: Center(
                      child: DragTarget<int>(
                        onWillAcceptWithDetails: (_) => true,
                        onAcceptWithDetails: (details) {
                          _onGridDragAccept(details.data, cellSize);
                        },
                        onMove: (details) {
                          _onGridDragUpdate(
                            DragUpdateDetails(
                              globalPosition: details.offset,
                            ),
                            cellSize,
                          );
                        },
                        onLeave: (_) {
                          setState(() {
                            _hoverRow = null;
                            _hoverCol = null;
                            _canPlaceHover = false;
                          });
                        },
                        builder: (context, candidateData, rejectedData) {
                          return GameGrid(
                            key: _gridKey,
                            gameState: _gameState,
                            cellSize: cellSize,
                            hoverPiece: _draggingPiece,
                            hoverRow: _hoverRow,
                            hoverCol: _hoverCol,
                            canPlaceHover: _canPlaceHover,
                            clearAnimation: _clearAnimController,
                            clearingRows: _clearingRows,
                            clearingCols: _clearingCols,
                          );
                        },
                      ),
                    ),
                  ),

                  // Piece tray
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: PieceTray(
                      pieces: _gameState.availablePieces,
                      cellSize: trayCellSize,
                      onDragStarted: _onDragStarted,
                      onDragEnd: _onDragEnd,
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
