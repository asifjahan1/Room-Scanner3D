import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../models/room_label.dart';
import '../models/room_scan.dart';
import '../controllers/project_controller.dart';
import '../widgets/room_type_button.dart';
import '../core/routes/app_routes.dart';

class RoomLabelScreen extends StatefulWidget {
  final RoomScan? roomScan;

  const RoomLabelScreen({
    super.key,
    this.roomScan,
  });

  @override
  State<RoomLabelScreen> createState() => _RoomLabelScreenState();
}

class _RoomLabelScreenState extends State<RoomLabelScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedRoomTypeId;
  RoomType _selectedRoomTypeEnum = RoomType.custom;
  final TextEditingController _labelController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _labelController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _selectRoomType(RoomLabelPreset type) {
    setState(() {
      _selectedRoomTypeId = type.id;
      _labelController.text = type.name;
      _selectedRoomTypeEnum = _mapPresetToRoomType(type.id);
    });
  }

  RoomType _mapPresetToRoomType(String id) {
    switch (id.toLowerCase()) {
      case 'living_room': return RoomType.livingRoom;
      case 'bedroom': return RoomType.bedroom;
      case 'kitchen': return RoomType.kitchen;
      case 'bathroom': return RoomType.bathroom;
      case 'office': return RoomType.office;
      case 'hallway': return RoomType.hallway;
      default: return RoomType.custom;
    }
  }

  Future<void> _navigateToFloorPlan() async {
    final originalScan = widget.roomScan ?? (Get.arguments as RoomScan?);
    final finalLabel = _labelController.text.trim().isNotEmpty ? _labelController.text.trim() : 'Scanned Room';
    
    if (originalScan == null || originalScan.walls.isEmpty) {
      Get.snackbar(
        'No Scan Data',
        'No valid room scan data available. Please rescan the room.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
      return;
    }

    final finalScan = originalScan.copyWith(
      label: finalLabel,
      roomType: _selectedRoomTypeEnum,
    );

    // Persist scan to ProjectController so it appears in recent scans and current project
    if (Get.isRegistered<ProjectController>()) {
      await Get.find<ProjectController>().addRoomToCurrentProject(finalScan);
    }

    Get.offNamed(AppRoutes.floorPlan, arguments: finalScan);
  }

  void _rescan() {
    Get.offNamed(AppRoutes.scanning);
  }

  @override
  Widget build(BuildContext context) {
    final scan = widget.roomScan ?? (Get.arguments as RoomScan?);
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: AppTheme.primaryBlue,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Text(
                      'Categorize & Label Room',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Room Thumbnail Preview Box
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderDark),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.space_dashboard_outlined,
                        size: 44,
                        color: AppTheme.accentTeal,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${scan?.walls.length ?? 4} Walls Detected',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Input field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Custom Room Name',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _labelController,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'e.g. Master Bedroom, Basement',
                        hintStyle: const TextStyle(color: AppTheme.textTertiary),
                        filled: true,
                        fillColor: AppTheme.bgCard,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppTheme.borderDark),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppTheme.borderDark),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppTheme.primaryBlue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Preset room labels grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: RoomLabelPreset.presets.length,
                  itemBuilder: (context, index) {
                    final type = RoomLabelPreset.presets[index];
                    final isSelected = _selectedRoomTypeId == type.id;
                    return RoomTypeButton(
                      label: type.name,
                      icon: type.icon,
                      isSelected: isSelected,
                      onTap: () => _selectRoomType(type),
                    );
                  },
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _rescan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.bgCard,
                            side: const BorderSide(color: AppTheme.dangerRed),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Rescan',
                            style: TextStyle(
                              color: AppTheme.dangerRed,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _navigateToFloorPlan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentTeal,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Generate Plan',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
