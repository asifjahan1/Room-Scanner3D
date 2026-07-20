import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/room_scan.dart';
import '../services/floor_plan_generator.dart';

class FloorPlanScreen extends StatefulWidget {
  final String roomLabel;
  final RoomScan? roomScan;

  const FloorPlanScreen({
    super.key,
    required this.roomLabel,
    this.roomScan,
  });

  @override
  State<FloorPlanScreen> createState() => _FloorPlanScreenState();
}

class _FloorPlanScreenState extends State<FloorPlanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  bool _showDimensions = true;
  bool _isMetric = true;

  // Demo floor plan data
  late List<Point2D> _floorPlanPoints;
  late double _area;
  late double _perimeter;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();

    // Generate demo data or use real scan data
    if (widget.roomScan != null) {
      _floorPlanPoints = FloorPlanGenerator.generateFloorPlan(widget.roomScan!);
      _area = widget.roomScan!.area ?? FloorPlanGenerator.calculateArea(_floorPlanPoints);
      _perimeter = widget.roomScan!.perimeter ?? FloorPlanGenerator.calculatePerimeter(_floorPlanPoints);
    } else {
      _generateDemoData();
    }
  }

  void _generateDemoData() {
    // Demo room shape
    _floorPlanPoints = const [
      Point2D(0, 0),
      Point2D(4.5, 0),
      Point2D(4.5, 3.2),
      Point2D(2.8, 3.2),
      Point2D(2.8, 5.0),
      Point2D(0, 5.0),
    ];
    _area = FloorPlanGenerator.calculateArea(_floorPlanPoints);
    _perimeter = FloorPlanGenerator.calculatePerimeter(_floorPlanPoints);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgDark,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          icon: const Icon(Icons.close, color: AppTheme.textPrimary),
        ),
        title: Text(
          widget.roomLabel,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Export options
              _showExportDialog();
            },
            icon: const Icon(Icons.share, color: AppTheme.textPrimary),
          ),
          IconButton(
            onPressed: () {
              setState(() => _showDimensions = !_showDimensions);
            },
            icon: Icon(
              _showDimensions ? Icons.straighten : Icons.straighten_outlined,
              color: _showDimensions
                  ? AppTheme.accentTeal
                  : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Unit toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildUnitToggle('Metric (m)', true),
                  const SizedBox(width: 8),
                  _buildUnitToggle('Imperial (ft)', false),
                ],
              ),
            ),

            // Floor Plan View
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    border: Border.all(color: AppTheme.borderDark),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return CustomPaint(
                          size: Size(constraints.maxWidth, constraints.maxHeight),
                          painter: _FloorPlanPainter(
                            points: _floorPlanPoints,
                            showDimensions: _showDimensions,
                            isMetric: _isMetric,
                            roomLabel: widget.roomLabel,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Room Info Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      'Area',
                      _isMetric
                          ? '${_area.toStringAsFixed(1)} m²'
                          : '${(_area * 10.7639).toStringAsFixed(1)} ft²',
                      Icons.square_foot,
                      AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoCard(
                      'Perimeter',
                      _isMetric
                          ? '${_perimeter.toStringAsFixed(1)} m'
                          : '${(_perimeter * 3.28084).toStringAsFixed(1)} ft',
                      Icons.border_all,
                      AppTheme.accentTeal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoCard(
                      'Walls',
                      '${_floorPlanPoints.length}',
                      Icons.border_left,
                      AppTheme.wireframeGlow,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMedium),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.doneButtonBg.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Save & Done',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitToggle(String label, bool isMetric) {
    final isSelected = _isMetric == isMetric;
    return GestureDetector(
      onTap: () => setState(() => _isMetric = isMetric),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryBlue
                : AppTheme.borderDark,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryBlue : AppTheme.textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.textTertiary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.borderDark,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Export Floor Plan',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              _buildExportOption(Icons.picture_as_pdf, 'PDF', 'Document format'),
              _buildExportOption(Icons.image, 'PNG Image', 'High-res image'),
              _buildExportOption(Icons.view_in_ar, 'USDZ', '3D model format'),
              _buildExportOption(Icons.data_object, 'JSON', 'Raw data'),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExportOption(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Icon(icon, color: AppTheme.primaryBlue),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppTheme.textTertiary, fontSize: 12),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppTheme.textTertiary,
        size: 16,
      ),
      onTap: () => Navigator.pop(context),
    );
  }
}

/// Floor plan painter
class _FloorPlanPainter extends CustomPainter {
  final List<Point2D> points;
  final bool showDimensions;
  final bool isMetric;
  final String roomLabel;

  _FloorPlanPainter({
    required this.points,
    required this.showDimensions,
    required this.isMetric,
    required this.roomLabel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final padding = 60.0;

    // Calculate bounds
    double minX = double.infinity, maxX = double.negativeInfinity;
    double minY = double.infinity, maxY = double.negativeInfinity;
    for (final p in points) {
      if (p.x < minX) minX = p.x;
      if (p.x > maxX) maxX = p.x;
      if (p.y < minY) minY = p.y;
      if (p.y > maxY) maxY = p.y;
    }

    final rangeX = maxX - minX;
    final rangeY = maxY - minY;
    if (rangeX == 0 && rangeY == 0) return;

    final availW = size.width - 2 * padding;
    final availH = size.height - 2 * padding;
    final scale = min(
      availW / (rangeX == 0 ? 1 : rangeX),
      availH / (rangeY == 0 ? 1 : rangeY),
    );

    final offsetX = padding + (availW - rangeX * scale) / 2;
    final offsetY = padding + (availH - rangeY * scale) / 2;

    Offset toCanvas(Point2D p) {
      return Offset(
        offsetX + (p.x - minX) * scale,
        offsetY + (p.y - minY) * scale,
      );
    }

    // Fill
    final fillPaint = Paint()
      ..color = AppTheme.primaryBlue.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    final fillPath = Path();
    final canvasPoints = points.map(toCanvas).toList();
    fillPath.moveTo(canvasPoints.first.dx, canvasPoints.first.dy);
    for (int i = 1; i < canvasPoints.length; i++) {
      fillPath.lineTo(canvasPoints[i].dx, canvasPoints[i].dy);
    }
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    // Walls
    final wallPaint = Paint()
      ..color = AppTheme.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(fillPath, wallPaint);

    // Corner dots
    final dotPaint = Paint()
      ..color = AppTheme.primaryBlue
      ..style = PaintingStyle.fill;

    for (final cp in canvasPoints) {
      canvas.drawCircle(cp, 4, dotPaint);
    }

    // Dimensions
    if (showDimensions) {
      for (int i = 0; i < points.length; i++) {
        final j = (i + 1) % points.length;
        final dx = points[j].x - points[i].x;
        final dy = points[j].y - points[i].y;
        final length = sqrt(dx * dx + dy * dy);

        final mid = Offset(
          (canvasPoints[i].dx + canvasPoints[j].dx) / 2,
          (canvasPoints[i].dy + canvasPoints[j].dy) / 2,
        );

        // Perpendicular offset for label
        final angle = atan2(
          canvasPoints[j].dy - canvasPoints[i].dy,
          canvasPoints[j].dx - canvasPoints[i].dx,
        );
        final labelOffset = Offset(
          -sin(angle) * 20,
          cos(angle) * 20,
        );

        final String label;
        if (isMetric) {
          label = '${length.toStringAsFixed(2)}m';
        } else {
          label = '${(length * 3.28084).toStringAsFixed(1)}ft';
        }

        final textPainter = TextPainter(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: AppTheme.accentTeal,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        // Background for label
        final labelRect = Rect.fromCenter(
          center: mid + labelOffset,
          width: textPainter.width + 12,
          height: textPainter.height + 6,
        );

        final bgPaint = Paint()
          ..color = AppTheme.bgCard
          ..style = PaintingStyle.fill;
        final bgBorder = Paint()
          ..color = AppTheme.borderDark
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        canvas.drawRRect(
          RRect.fromRectAndRadius(labelRect, const Radius.circular(4)),
          bgPaint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(labelRect, const Radius.circular(4)),
          bgBorder,
        );

        textPainter.paint(
          canvas,
          Offset(
            labelRect.left + 6,
            labelRect.top + 3,
          ),
        );
      }
    }

    // Room label in center
    final centerX = canvasPoints.fold(0.0, (sum, p) => sum + p.dx) / canvasPoints.length;
    final centerY = canvasPoints.fold(0.0, (sum, p) => sum + p.dy) / canvasPoints.length;

    final labelPainter = TextPainter(
      text: TextSpan(
        text: roomLabel,
        style: TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    labelPainter.paint(
      canvas,
      Offset(centerX - labelPainter.width / 2, centerY - labelPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _FloorPlanPainter oldDelegate) {
    return oldDelegate.showDimensions != showDimensions ||
        oldDelegate.isMetric != isMetric ||
        oldDelegate.roomLabel != roomLabel;
  }
}
