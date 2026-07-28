import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_card.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../core/routes/app_routes.dart';

class UpdateProgressController extends GetxController {
  // 0: Started, 1: Going well, 2: Needs attention
  final RxInt selectedStatus = 1.obs;

  void selectStatus(int index) {
    selectedStatus.value = index;
  }
}

class UpdateProgressScreen extends StatelessWidget {
  const UpdateProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateProgressController());

    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: PerfektTheme.backgroundLight,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: PerfektTheme.primaryBlue,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'UPDATE PROGRESS',
            style: PerfektTheme.fontBold(
              16,
              color: PerfektTheme.primaryBlue,
            ).copyWith(letterSpacing: 1.0),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 22.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Select Task Dropdown Box
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: PerfektTheme.radiusCard,
                    border: Border.all(color: PerfektTheme.borderLight),
                    boxShadow: PerfektTheme.cardShadow,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.assignment_outlined,
                        color: PerfektTheme.primaryBlue,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Select Task",
                          style: PerfektTheme.fontMedium(
                            15,
                            color: PerfektTheme.textDark,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: PerfektTheme.textLight,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),

                // How is it going Title
                Text(
                  "How is it going?",
                  style: PerfektTheme.fontBold(
                    24,
                    color: PerfektTheme.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Select the current status for Building A - Floor 4",
                  style: PerfektTheme.fontRegular(
                    14,
                    color: PerfektTheme.textMedium,
                  ),
                ),
                const SizedBox(height: 20),

                // Status Option Cards
                Obx(
                  () => Column(
                    children: [
                      _buildStatusCard(
                        index: 0,
                        selected: controller.selectedStatus.value == 0,
                        title: "Started",
                        subtitle: "Work has officially begun",
                        icon: Icons.info_outline_rounded,
                        iconColor: PerfektTheme.textMedium,
                        iconBgColor: PerfektTheme.surfaceGrey,
                        onTap: () => controller.selectStatus(0),
                      ),
                      const SizedBox(height: 12),
                      _buildStatusCard(
                        index: 1,
                        selected: controller.selectedStatus.value == 1,
                        title: "Going well",
                        subtitle: "On schedule and no blockers",
                        icon: Icons.check_circle_rounded,
                        iconColor: Colors.white,
                        iconBgColor: PerfektTheme.primaryBlue,
                        onTap: () => controller.selectStatus(1),
                        showCheckmarks: true,
                      ),
                      const SizedBox(height: 12),
                      _buildStatusCard(
                        index: 2,
                        selected: controller.selectedStatus.value == 2,
                        title: "Needs attention",
                        subtitle: "Facing issues or delays",
                        icon: Icons.warning_amber_rounded,
                        iconColor: const Color(0xFFDC2626),
                        iconBgColor: const Color(0xFFFEE2E2),
                        onTap: () => controller.selectStatus(2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Center Speak Update Button
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.voiceUpdate),
                        child: Container(
                          width: 86,
                          height: 86,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: PerfektTheme.primaryBlue,
                            boxShadow: [
                              BoxShadow(
                                color: PerfektTheme.primaryBlue.withValues(
                                  alpha: 0.35,
                                ),
                                blurRadius: 22,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.mic_none_rounded,
                              color: Colors.white,
                              size: 38,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "SPEAK UPDATE",
                        style: PerfektTheme.fontBold(
                          13,
                          color: PerfektTheme.primaryBlue,
                        ).copyWith(letterSpacing: 1.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Transcribed Note Preview Card
                PerfektCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.description_outlined,
                                size: 18,
                                color: PerfektTheme.textLight,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "TRANSCRIBED NOTE",
                                style: PerfektTheme.fontBold(
                                  11,
                                  color: PerfektTheme.textLight,
                                ).copyWith(letterSpacing: 0.8),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => Get.toNamed(AppRoutes.voiceUpdate),
                            child: Text(
                              "Edit",
                              style: PerfektTheme.fontBold(
                                13,
                                color: PerfektTheme.primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '"Wall framing 65% complete. Waiting for more studs."',
                        style: PerfektTheme.fontMedium(
                          14,
                          color: PerfektTheme.textDark,
                        ).copyWith(fontStyle: FontStyle.italic, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Add photo button (white card style)
                GestureDetector(
                  onTap: () => Get.snackbar(
                    'Photo Added',
                    'Camera attachment linked to progress report.',
                    snackPosition: SnackPosition.TOP,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: PerfektTheme.radiusCard,
                      border: Border.all(color: PerfektTheme.borderLight),
                      boxShadow: PerfektTheme.cardShadow,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          color: PerfektTheme.primaryBlue,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Add photo",
                          style: PerfektTheme.fontBold(
                            15,
                            color: PerfektTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Send update solid button
                PerfektButton(
                  label: "Send update",
                  trailingIcon: Icons.send_rounded,
                  height: 54,
                  fontSize: 16,
                  onPressed: () => Get.toNamed(AppRoutes.progressSent),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required int index,
    required bool selected,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required VoidCallback onTap,
    bool showCheckmarks = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: PerfektTheme.radiusCard,
          border: Border.all(
            color: selected
                ? PerfektTheme.primaryBlue
                : PerfektTheme.borderLight,
            width: selected ? 2.0 : 1.0,
          ),
          boxShadow: PerfektTheme.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: PerfektTheme.fontBold(
                      16,
                      color: selected
                          ? PerfektTheme.primaryBlue
                          : PerfektTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: PerfektTheme.fontRegular(
                      13,
                      color: selected
                          ? PerfektTheme.primaryBlue.withValues(alpha: 0.85)
                          : PerfektTheme.textMedium,
                    ),
                  ),
                ],
              ),
            ),
            if (showCheckmarks && selected)
              const Icon(
                Icons.done_all_rounded,
                color: PerfektTheme.primaryBlue,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
