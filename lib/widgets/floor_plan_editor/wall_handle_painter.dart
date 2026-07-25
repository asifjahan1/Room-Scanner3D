import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/floor_plan_element.dart';
import '../../core/utils/measurement_utils.dart';

/// Painter that draws architectural floor plan walls with interactive corner handles,
/// grid lines, openings, and measurement annotations.
class WallHandlePainter extends CustomPainter {
  final List<EditableWall> walls;
  final List<EditableOpening> openings;
  final String? selectedElementId;
  final bool showDimensions;
  final bool showGrid;
  final bool isMetric;
  final double scale;

  WallHandlePainter({
    required this.walls,
    required this.openings,
    this.selectedElementId,
    this.showDimensions = true,
    this.showGrid = false,
    this.isMetric = true,
    this.scale = 40.0, // Pixels per meter
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Draw background grid if enabled
    if (showGrid) {
      _drawGrid(canvas, size);
    }

    // Transform points from real meters to canvas pixel coordinates
    Offset toCanvas(double x, double y) {
      return Offset(cx + x * scale, cy + y * scale);
    }

    // Draw openings (doors and windows) first if detached, or along walls
    for (final opening in openings) {
      final pos = toCanvas(opening.x, opening.y);
      final isSelected = opening.id == selectedElementId;
      _drawOpeningSymbol(canvas, pos, opening, isSelected);
    }

    // Draw walls
    for (final wall in walls) {
      final p1 = toCanvas(wall.start.x, wall.start.y);
      final p2 = toCanvas(wall.end.x, wall.end.y);
      final isSelected = wall.id == selectedElementId;

      // Wall shadow/glow when selected
      if (isSelected) {
        final glowPaint = Paint()
          ..color = AppTheme.primaryBlue.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = wall.thickness * scale + 8
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawLine(p1, p2, glowPaint);
      }

      // Wall body (fill thickness)
      final wallFillPaint = Paint()
        ..color = isSelected ? AppTheme.primaryBlue : AppTheme.wireframeWhite.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (wall.thickness * scale).clamp(6.0, 30.0)
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(p1, p2, wallFillPaint);

      // Wall center outline
      final wallLinePaint = Paint()
        ..color = isSelected ? Colors.white : AppTheme.bgDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawLine(p1, p2, wallLinePaint);

      // Draw dimension text if enabled
      if (showDimensions && wall.length > 0.1) {
        _drawDimensionText(canvas, p1, p2, wall.length);
      }

      // Draw endpoint manipulation handles (circles at start and end)
      if (isSelected) {
        _drawHandle(canvas, p1, isPrimary: true);
        _drawHandle(canvas, p2, isPrimary: false);
      } else {
        _drawNeutralCornerDot(canvas, p1);
        _drawNeutralCornerDot(canvas, p2);
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const spacing = 20.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawHandle(Canvas canvas, Offset pos, {required bool isPrimary}) {
    final fillPaint = Paint()
      ..color = isPrimary ? AppTheme.accentTeal : AppTheme.warningOrange
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(pos, 8.0, fillPaint);
    canvas.drawCircle(pos, 8.0, borderPaint);
  }

  void _drawNeutralCornerDot(Canvas canvas, Offset pos) {
    final dotPaint = Paint()
      ..color = AppTheme.textSecondary.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pos, 3.5, dotPaint);
  }

  void _drawOpeningSymbol(Canvas canvas, Offset pos, EditableOpening opening, bool isSelected) {
    final paint = Paint()
      ..color = isSelected ? AppTheme.accentTeal : Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final widthPx = opening.width * scale;
    final rect = Rect.fromCenter(center: pos, width: widthPx, height: 12);
    if (opening.type == 'door') {
      // Draw door arc
      canvas.drawArc(rect, 0, pi / 2, false, paint);
    } else {
      // Draw window parallel lines
      canvas.drawRect(rect, paint);
    }
  }

  void _drawDimensionText(Canvas canvas, Offset p1, Offset p2, double lengthMeters) {
    final textStr = MeasurementUtils.formatLength(lengthMeters, isMetric: isMetric);

    final mid = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    var angle = atan2(dy, dx);
    if (angle > pi / 2 || angle < -pi / 2) {
      angle += pi;
    }

    final textSpan = TextSpan(
      text: textStr,
      style: const TextStyle(
        color: AppTheme.accentTeal,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    canvas.save();
    canvas.translate(mid.dx, mid.dy);
    canvas.rotate(angle);
    canvas.translate(-textPainter.width / 2, -14);

    final bgRect = Rect.fromLTWH(-4, -2, textPainter.width + 8, textPainter.height + 4);
    final bgPaint = Paint()
      ..color = AppTheme.bgDark.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = AppTheme.accentTeal.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(4)), bgPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(4)), borderPaint);
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant WallHandlePainter oldDelegate) {
    return true;
  }
}
