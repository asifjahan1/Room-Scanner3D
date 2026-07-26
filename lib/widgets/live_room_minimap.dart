import 'dart:math';
import 'package:flutter/material.dart';

/// Transparent Live 3D Room Mini-Model (Apple RoomPlan & MeasureSquare dollhouse style).
/// Floats seamlessly above the bottom Done button during 3D AR room capture.
class LiveRoomMiniMap extends StatefulWidget {
  final int wallsDetected;
  final bool isScanning;

  const LiveRoomMiniMap({
    super.key,
    required this.wallsDetected,
    required this.isScanning,
  });

  @override
  State<LiveRoomMiniMap> createState() => _LiveRoomMiniMapState();
}

class _LiveRoomMiniMapState extends State<LiveRoomMiniMap>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 16),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isScanning && widget.wallsDetected == 0) {
      return const SizedBox.shrink();
    }

    // Completely transparent container so the 3D room model floats right over the camera video!
    return SizedBox(
      width: 180,
      height: 130,
      child: AnimatedBuilder(
        animation: _rotationController,
        builder: (context, child) {
          return CustomPaint(
            painter: _IsometricRoomPainter(
              wallsDetected: widget.wallsDetected,
              rotationAngle: _rotationController.value * 2 * pi,
            ),
          );
        },
      ),
    );
  }
}

class _IsometricRoomPainter extends CustomPainter {
  final int wallsDetected;
  final double rotationAngle;

  _IsometricRoomPainter({
    required this.wallsDetected,
    required this.rotationAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 12;
    final w = size.width * 0.52;
    final h = size.height * 0.40;
    const wallHeight = 38.0;

    // Projected floor boundary corners
    final f1 = _project3D(cx, cy, -w / 2, 0, -h / 2, rotationAngle);
    final f2 = _project3D(cx, cy, w / 2, 0, -h / 2, rotationAngle);
    final f3 = _project3D(cx, cy, w / 2, 0, h / 2, rotationAngle);
    final f4 = _project3D(cx, cy, -w / 2, 0, h / 2, rotationAngle);

    // Floor base path
    final floorPath = Path()
      ..moveTo(f1.dx, f1.dy)
      ..lineTo(f2.dx, f2.dy)
      ..lineTo(f3.dx, f3.dy)
      ..lineTo(f4.dx, f4.dy)
      ..close();

    final floorFill = Paint()
      ..color = Colors.white.withValues(alpha: 0.14)
      ..style = PaintingStyle.fill;

    final floorBorder = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawPath(floorPath, floorFill);
    canvas.drawPath(floorPath, floorBorder);

    // 3D Wall extruded rendering styles (Crisp White Apple RoomPlan AR aesthetic)
    final wallFill = Paint()
      ..color = Colors.white.withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;

    final wallBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final glowBorder = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // Determine how many walls to render (if 0 detected yet, render an initial glowing anchor corner)
    final activeWalls = wallsDetected == 0 ? 1 : wallsDetected;

    if (activeWalls >= 1) {
      _drawWallPanel(canvas, f1, f2, wallHeight, wallFill, wallBorder, glowBorder);
    }
    if (activeWalls >= 2) {
      _drawWallPanel(canvas, f2, f3, wallHeight, wallFill, wallBorder, glowBorder);
    }
    if (activeWalls >= 3) {
      _drawWallPanel(canvas, f3, f4, wallHeight, wallFill, wallBorder, glowBorder);
    }
    if (activeWalls >= 4) {
      _drawWallPanel(canvas, f4, f1, wallHeight, wallFill, wallBorder, glowBorder);
    }

    // Glowing anchor vertex joints at corner junctions
    final cornerGlow = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    final cornerDot = Paint()
      ..color = const Color(0xFF00E5FF)
      ..style = PaintingStyle.fill;

    for (final pt in [f1, f2, f3, f4]) {
      canvas.drawCircle(pt, 3.5, cornerGlow);
      canvas.drawCircle(pt, 2.5, cornerDot);
    }
  }

  void _drawWallPanel(
    Canvas canvas,
    Offset b1,
    Offset b2,
    double wallHeight,
    Paint fill,
    Paint border,
    Paint glow,
  ) {
    final t1 = Offset(b1.dx, b1.dy - wallHeight);
    final t2 = Offset(b2.dx, b2.dy - wallHeight);

    final path = Path()
      ..moveTo(b1.dx, b1.dy)
      ..lineTo(b2.dx, b2.dy)
      ..lineTo(t2.dx, t2.dy)
      ..lineTo(t1.dx, t1.dy)
      ..close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, glow);
    canvas.drawPath(path, border);
  }

  Offset _project3D(
    double cx,
    double cy,
    double x,
    double y,
    double z,
    double angle,
  ) {
    final rx = x * cos(angle) - z * sin(angle);
    final rz = x * sin(angle) + z * cos(angle);

    final px = cx + (rx - rz) * cos(pi / 6);
    final py = cy + (rx + rz) * sin(pi / 6) - y;

    return Offset(px, py);
  }

  @override
  bool shouldRepaint(covariant _IsometricRoomPainter oldDelegate) {
    return oldDelegate.wallsDetected != wallsDetected ||
        oldDelegate.rotationAngle != rotationAngle;
  }
}
