import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../theme/app_theme.dart';
import '../models/room_scan.dart';
import '../controllers/floor_plan_controller.dart';
import '../controllers/export_controller.dart';
import '../widgets/floor_plan_editor/wall_handle_painter.dart';
import '../widgets/floor_plan_editor/dimension_label_widget.dart';
import '../widgets/floor_plan_editor/toolbar_widget.dart';
import '../widgets/floor_plan_editor/door_widget.dart';
import '../core/routes/app_routes.dart';

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

class _FloorPlanScreenState extends State<FloorPlanScreen> {
  final FloorPlanController controller = Get.find<FloorPlanController>();
  final ExportController exportController = Get.put(ExportController());

  @override
  void initState() {
    super.initState();
    final effectiveScan = widget.roomScan ?? (Get.arguments as RoomScan?) ?? _createDemoScan();
    controller.loadFromScan(effectiveScan);
    controller.roomLabel.value = widget.roomLabel;
  }

  RoomScan _createDemoScan() {
    const uuid = Uuid();
    return RoomScan(
      id: uuid.v4(),
      label: widget.roomLabel,
      roomType: RoomType.custom,
      scannedAt: DateTime.now(),
      walls: const [
        WallSegment(start: Point3D(-2.0, 0.0, -1.5), end: Point3D(2.0, 0.0, -1.5)),
        WallSegment(start: Point3D(2.0, 0.0, -1.5), end: Point3D(2.0, 0.0, 1.5)),
        WallSegment(start: Point3D(2.0, 0.0, 1.5), end: Point3D(-2.0, 0.0, 1.5)),
        WallSegment(start: Point3D(-2.0, 0.0, 1.5), end: Point3D(-2.0, 0.0, -1.5)),
      ],
      area: 12.0,
      perimeter: 14.0,
    );
  }

  void _handleCanvasTap(Offset localPosition, Size canvasSize) {
    final cx = canvasSize.width / 2;
    final cy = canvasSize.height / 2;
    const scale = 40.0;

    Offset toCanvas(double x, double y) => Offset(cx + x * scale, cy + y * scale);

    // Check if tap hit any wall
    for (final wall in controller.walls) {
      final p1 = toCanvas(wall.start.x, wall.start.y);
      final p2 = toCanvas(wall.end.x, wall.end.y);
      final dist = _pointToSegmentDistance(localPosition, p1, p2);
      if (dist < 20.0) {
        controller.selectElement(wall.id);
        return;
      }
    }

    // Check if tap hit any opening
    for (final op in controller.openings) {
      final pos = toCanvas(op.x, op.y);
      if ((localPosition - pos).distance < 24.0) {
        controller.selectElement(op.id);
        return;
      }
    }

    // Otherwise deselect
    controller.deselectAll();
  }

  double _pointToSegmentDistance(Offset p, Offset a, Offset b) {
    final l2 = (b - a).distanceSquared;
    if (l2 == 0) return (p - a).distance;
    var t = ((p.dx - a.dx) * (b.dx - a.dx) + (p.dy - a.dy) * (b.dy - a.dy)) / l2;
    t = t.clamp(0.0, 1.0);
    final projection = Offset(a.dx + t * (b.dx - a.dx), a.dy + t * (b.dy - a.dy));
    return (p - projection).distance;
  }

  void _showExportModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXLarge)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Export & Share Floor Plan',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose your preferred industry-standard format:',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 20),
            _buildExportOption(
              icon: Icons.picture_as_pdf_outlined,
              title: 'PDF Blueprint Summary',
              subtitle: 'Comprehensive document with calculation tables and layout',
              onTap: () {
                Navigator.pop(ctx);
                exportController.setFormat('pdf');
                exportController.exportAndShare(
                  widget.roomScan ?? _createDemoScan(),
                  isMetric: controller.isMetric.value,
                );
              },
            ),
            const SizedBox(height: 12),
            _buildExportOption(
              icon: Icons.data_object_outlined,
              title: 'JSON Raw Geometry',
              subtitle: 'Complete coordinates, wall thicknesses and 3D mesh vectors',
              onTap: () {
                Navigator.pop(ctx);
                exportController.setFormat('json');
                exportController.exportAndShare(widget.roomScan ?? _createDemoScan());
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Icon(icon, color: AppTheme.primaryBlue),
      ),
      title: Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppTheme.textTertiary, fontSize: 12)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        side: const BorderSide(color: AppTheme.borderDark),
      ),
      tileColor: AppTheme.bgSurface,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgDark,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.offAllNamed(AppRoutes.home),
          icon: const Icon(Icons.close, color: AppTheme.textPrimary),
          tooltip: 'Close Editor',
        ),
        title: Obx(() => Text(
              controller.roomLabel.value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showExportModal(context),
            icon: const Icon(Icons.ios_share, color: AppTheme.textPrimary),
            tooltip: 'Export',
          ),
          IconButton(
            onPressed: () => controller.showDimensions.toggle(),
            icon: Obx(() => Icon(
                  controller.showDimensions.value ? Icons.straighten : Icons.straighten_outlined,
                  color: controller.showDimensions.value ? AppTheme.accentTeal : AppTheme.textSecondary,
                )),
            tooltip: 'Toggle Dimensions',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main Interactive Editing Canvas
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                return GestureDetector(
                  onTapUp: (details) => _handleCanvasTap(details.localPosition, size),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                      border: Border.all(color: AppTheme.borderDark),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                      child: Obx(() => CustomPaint(
                            painter: WallHandlePainter(
                              walls: controller.walls.toList(),
                              openings: controller.openings.toList(),
                              selectedElementId: controller.selectedElementId.value,
                              showDimensions: controller.showDimensions.value,
                              showGrid: controller.showGrid.value,
                              isMetric: controller.isMetric.value,
                            ),
                          )),
                    ),
                  ),
                );
              },
            ),
          ),

          // Floating Top Dimension Bar
          Positioned(
            top: 28,
            left: 0,
            right: 0,
            child: Center(
              child: Obx(() => DimensionLabelWidget(
                    areaSqMeters: controller.totalArea,
                    perimeterMeters: controller.totalPerimeter,
                    isMetric: controller.isMetric.value,
                    onToggleUnits: () => controller.isMetric.toggle(),
                  )),
            ),
          ),

          // Opening Configuration Panel (if an opening is currently selected)
          Obx(() {
            final selId = controller.selectedElementId.value;
            final opening = controller.openings.firstWhereOrNull((o) => o.id == selId);
            if (opening == null) return const SizedBox.shrink();
            return Positioned(
              bottom: 140,
              left: 24,
              right: 24,
              child: DoorWidget(
                opening: opening,
                onWidthChanged: (val) {
                  opening.width = val;
                  controller.openings.refresh();
                },
                onDelete: () => controller.deleteOpening(opening.id),
              ),
            );
          }),

          // Floating Editor Toolbar & Save Action
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => ToolbarWidget(
                      canUndo: controller.canUndo.value,
                      canRedo: controller.canRedo.value,
                      hasSelection: controller.selectedElementId.value != null,
                      showGrid: controller.showGrid.value,
                      onUndo: controller.undo,
                      onRedo: controller.redo,
                      onAddDoor: () => controller.addDoor(controller.selectedElementId.value),
                      onAddWindow: () => controller.addWindow(controller.selectedElementId.value),
                      onSplitWall: () {
                        final id = controller.selectedElementId.value;
                        if (id != null) controller.splitWall(id);
                      },
                      onDeleteSelected: () {
                        final id = controller.selectedElementId.value;
                        if (id != null) controller.deleteWall(id);
                      },
                      onToggleGrid: () => controller.showGrid.toggle(),
                      onExport: () => _showExportModal(context),
                    )),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ElevatedButton(
                    onPressed: () => Get.offAllNamed(AppRoutes.home),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: AppTheme.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Save & Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
