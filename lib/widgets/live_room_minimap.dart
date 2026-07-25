import 'dart:math';
import 'package:flutter/material.dart';

/// Compact Live 3D Room Mini-Map visualization widget (Apple RoomPlan style)
/// Positioned at the bottom-left corner during room scanning
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
      duration: const Duration(seconds: 14),
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

    return Container(
      width: 105,
      height: 85,
      decoration: BoxDecoration(
        color: const Color(0xE6101018),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
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
    final cy = size.height / 2 + 8;
    final w = size.width * 0.42;
    final h = size.height * 0.32;
    final wallHeight = 24.0;

    // Floor points
    final f1 = _project3D(cx, cy, -w / 2, 0, -h / 2, rotationAngle);
    final f2 = _project3D(cx, cy, w / 2, 0, -h / 2, rotationAngle);
    final f3 = _project3D(cx, cy, w / 2, 0, h / 2, rotationAngle);
    final f4 = _project3D(cx, cy, -w / 2, 0, h / 2, rotationAngle);

    final floorPath = Path()
      ..moveTo(f1.dx, f1.dy)
      ..lineTo(f2.dx, f2.dy)
      ..lineTo(f3.dx, f3.dy)
      ..lineTo(f4.dx, f4.dy)
      ..close();

    final floorFill = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final floorBorder = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(floorPath, floorFill);
    canvas.drawPath(floorPath, floorBorder);

    // Wall paints
    final wallFill = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final wallBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final glowBorder = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    if (wallsDetected >= 1) {
      _drawWallPanel(canvas, f1, f2, wallHeight, wallFill, wallBorder, glowBorder);
    }
    if (wallsDetected >= 2) {
      _drawWallPanel(canvas, f2, f3, wallHeight, wallFill, wallBorder, glowBorder);
    }
    if (wallsDetected >= 3) {
      _drawWallPanel(canvas, f3, f4, wallHeight, wallFill, wallBorder, glowBorder);
    }
    if (wallsDetected >= 4) {
      _drawWallPanel(canvas, f4, f1, wallHeight, wallFill, wallBorder, glowBorder);
    }

    final cornerDot = Paint()
      ..color = const Color(0xFF00C7BE)
      ..style = PaintingStyle.fill;

    for (final pt in [f1, f2, f3, f4]) {
      canvas.drawCircle(pt, 2.0, cornerDot);
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
