import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/app_theme.dart';
import '../services/scanner_service.dart';
import '../controllers/project_controller.dart';
import '../models/room_scan.dart';
import '../core/routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isDeviceSupported = true;
  String _scanTech = '';

  final ProjectController controller = Get.find<ProjectController>();

  bool get isDeviceSupported => _isDeviceSupported;

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
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
    _checkSupport();
  }

  Future<void> _checkSupport() async {
    final supported = await ScannerService.isSupported();
    if (!mounted) return;
    setState(() {
      _isDeviceSupported = supported;
      _scanTech = ScannerService.scanningTechnology;
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _startScanFlow() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      Get.toNamed(AppRoutes.scanning);
    } else if (status.isPermanentlyDenied) {
      Get.dialog(
        AlertDialog(
          backgroundColor: AppTheme.bgCard,
          title: const Text('Camera Permission Required', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Room scanning requires camera access to detect walls and surfaces. Please enable camera permission in Settings.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                openAppSettings();
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
              child: const Text('Open Settings', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      Get.snackbar(
        'Permission Needed',
        'Camera permission is required to scan rooms.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.dangerRed.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    }
  }

  void _showCreateProjectDialog() {
    final textController = TextEditingController();
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLarge)),
        title: const Text('Create New Project', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700)),
        content: TextField(
          controller: textController,
          style: const TextStyle(color: AppTheme.textPrimary),
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. Master Bedroom Renovation',
            hintStyle: TextStyle(color: AppTheme.textTertiary),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.borderDark)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryBlue)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (textController.text.trim().isNotEmpty) {
                final proj = await controller.createProject(textController.text.trim());
                Get.back();
                controller.setCurrentProject(proj);
                Get.toNamed(AppRoutes.projectDetail);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
            child: const Text('Create', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: RefreshIndicator(
              color: AppTheme.primaryBlue,
              backgroundColor: AppTheme.bgCard,
              onRefresh: () => controller.loadProjects(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // App Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Room Scanner',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '3D LiDAR & ARCore AI Engine',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: AppTheme.accentTeal,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => Get.toNamed(AppRoutes.settings),
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.bgCard,
                              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                              border: Border.all(color: AppTheme.borderDark),
                            ),
                            child: const Icon(
                              Icons.settings_outlined,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Technology & Sensor Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryBlue.withValues(alpha: 0.15),
                            AppTheme.accentTeal.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.sensors, color: AppTheme.primaryBlue, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            _scanTech.isNotEmpty ? _scanTech : 'Detecting AR Hardware...',
                            style: const TextStyle(
                              color: AppTheme.primaryBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Main Hero Action Card - New Scan
                    _buildNewScanCard(),

                    const SizedBox(height: 32),

                    // Projects Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Projects', style: Theme.of(context).textTheme.headlineMedium),
                        TextButton.icon(
                          onPressed: _showCreateProjectDialog,
                          icon: const Icon(Icons.create_new_folder_outlined, color: AppTheme.primaryBlue, size: 18),
                          label: const Text(
                            'New Project',
                            style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Projects List
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator(color: AppTheme.primaryBlue),
                          ),
                        );
                      }
                      if (controller.projects.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.bgCard,
                            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                            border: Border.all(color: AppTheme.borderDark),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.folder_open_outlined, color: AppTheme.textTertiary, size: 36),
                              SizedBox(height: 10),
                              Text(
                                'No organized projects yet',
                                style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Create a project to bundle floor plans for complete buildings',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppTheme.textTertiary, fontSize: 13),
                              ),
                            ],
                          ),
                        );
                      }
                      return SizedBox(
                        height: 110,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.projects.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            final proj = controller.projects[index];
                            return _buildProjectTile(proj);
                          },
                        ),
                      );
                    }),

                    const SizedBox(height: 32),

                    // Recent Scans Section Header
                    Text('Recent Room Scans', style: Theme.of(context).textTheme.headlineMedium),

                    const SizedBox(height: 12),

                    // Recent Scans List
                    Obx(() {
                      final scans = controller.recentScans;
                      if (scans.isEmpty && controller.projects.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
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
                                Text(
                                  'No scans yet',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: AppTheme.textSecondary),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Start your first room scan above to\ngenerate real-time accurate blueprints',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: AppTheme.textTertiary),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      if (scans.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text('No individual scans recorded recently.', style: TextStyle(color: AppTheme.textTertiary)),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: scans.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => _buildRecentScanCard(scans[index]),
                      );
                    }),

                    const SizedBox(height: 36),

                    // Bottom Scanning Guidance Tip Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: AppTheme.bgCard,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        border: Border.all(color: AppTheme.borderDark),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppTheme.warningOrange.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                            ),
                            child: const Icon(Icons.lightbulb_outline, color: AppTheme.warningOrange, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pro Scanning Tip',
                                  style: TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Stand in the center of the room and aim camera slowly along floor-wall intersections.',
                                  style: TextStyle(color: AppTheme.textTertiary, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewScanCard() {
    return GestureDetector(
      onTap: _startScanFlow,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
          boxShadow: [
            BoxShadow(
              color: AppTheme.doneButtonBg.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
              child: const Icon(Icons.view_in_ar, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'New Room Scan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Real-time automated wall & corner extraction',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectTile(ScanProject project) {
    return InkWell(
      onTap: () {
        controller.setCurrentProject(project);
        Get.toNamed(AppRoutes.projectDetail);
      },
      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(color: AppTheme.borderDark),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.folder, color: AppTheme.primaryBlue, size: 28),
                Text(
                  '${project.rooms.length} room(s)',
                  style: const TextStyle(color: AppTheme.accentTeal, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Text(
              project.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentScanCard(RoomScan scan) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.floorPlan, arguments: scan),
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: AppTheme.borderDark),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.accentTeal.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Center(
                child: Text(scan.roomType.emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scan.label ?? scan.roomType.displayName,
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${scan.walls.length} walls • ${scan.area?.toStringAsFixed(1) ?? '—'} m²',
                    style: const TextStyle(color: AppTheme.textTertiary, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textTertiary, size: 22),
          ],
        ),
      ),
    );
  }
}
