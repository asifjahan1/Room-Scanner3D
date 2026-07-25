import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../controllers/project_controller.dart';
import '../controllers/export_controller.dart';
import '../models/room_scan.dart';
import '../core/routes/app_routes.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProjectController>();
    final exportController = Get.put(ExportController());

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgDark,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
        ),
        title: Obx(() => Text(
              controller.currentProject.value?.name ?? 'Project',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )),
        centerTitle: true,
        actions: [
          Obx(() {
            final proj = controller.currentProject.value;
            if (proj == null || proj.rooms.isEmpty) return const SizedBox.shrink();
            return IconButton(
              onPressed: () {
                exportController.exportAndShare(proj.rooms.first);
              },
              icon: const Icon(Icons.share, color: AppTheme.textPrimary),
              tooltip: 'Share Primary Plan',
            );
          }),
        ],
      ),
      body: Obx(() {
        final project = controller.currentProject.value;
        if (project == null) {
          return const Center(
            child: Text('No project selected',
                style: TextStyle(color: AppTheme.textSecondary)),
          );
        }

        if (project.rooms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.borderDark),
                  ),
                  child: const Icon(
                    Icons.view_in_ar_outlined,
                    color: AppTheme.textTertiary,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No rooms scanned yet',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap the button below to add a room',
                  style: TextStyle(color: AppTheme.textTertiary, fontSize: 14),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: project.rooms.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final room = project.rooms[index];
            return _buildRoomCard(context, room);
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.scanning),
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Room',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildRoomCard(BuildContext context, RoomScan room) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.floorPlan, arguments: room),
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: AppTheme.borderDark),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Center(
                child: Text(
                  room.roomType.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.label ?? room.roomType.displayName,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${room.walls.length} walls • ${room.area?.toStringAsFixed(1) ?? '—'} m²',
                    style: const TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppTheme.textTertiary, size: 22),
          ],
        ),
      ),
    );
  }
}
