import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../core/routes/app_routes.dart';

class NotificationsController extends GetxController {
  final RxString selectedFilter = 'unread'.obs;
  final RxInt unreadCount = 3.obs;

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  void markAllRead() {
    unreadCount.value = 0;
    Get.snackbar(
      "Notifications",
      "All notifications marked as read.",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: PerfektTheme.textDark,
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());

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
            'NOTIFICATION',
            style: PerfektTheme.fontBold(
              17,
              color: PerfektTheme.primaryBlue,
            ).copyWith(letterSpacing: 1.0),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subheader row (Title + MARK ALL READ)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Notifications",
                      style: PerfektTheme.fontBold(
                        22,
                        color: PerfektTheme.textDark,
                      ),
                    ),
                    TextButton(
                      onPressed: controller.markAllRead,
                      child: Text(
                        "MARK ALL READ",
                        style: PerfektTheme.fontBold(
                          12,
                          color: PerfektTheme.primaryBlue,
                        ).copyWith(letterSpacing: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Filter Capsule Buttons
                Obx(
                  () => Row(
                    children: [
                      _buildFilterPill(
                        label: "Unread (${controller.unreadCount.value})",
                        isSelected: controller.selectedFilter.value == 'unread',
                        onTap: () => controller.selectFilter('unread'),
                      ),
                      const SizedBox(width: 10),
                      _buildFilterPill(
                        label: "All",
                        isSelected: controller.selectedFilter.value == 'all',
                        onTap: () => controller.selectFilter('all'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Card 1: Material Request Approved
                _buildNotificationCard(
                  icon: Icons.assignment_turned_in_outlined,
                  iconBgColor: const Color(0xFFEFF6FF),
                  iconColor: PerfektTheme.primaryBlue,
                  title: "Material Request Approved",
                  description:
                      "Your request for 'Premium Concrete Mix' has been approved for delivery.",
                  actionButton: PerfektButton(
                    label: "Open",
                    onPressed: () => Get.toNamed(AppRoutes.materialRequests),
                  ),
                ),
                const SizedBox(height: 16),

                // Card 2: Measurement Approved (With Green Border accent on Left!)
                _buildNotificationCard(
                  icon: Icons.check_circle_outline_rounded,
                  iconBgColor: const Color(0xFFEFF6FF),
                  iconColor: PerfektTheme.primaryBlue,
                  title: "Measurement Approved",
                  description:
                      "Foreman Sarah approved 'Kitchen Wall' measurement.",
                  accentBorderColor: const Color(
                    0xFF10B981,
                  ), // Green Left Border
                ),
                const SizedBox(height: 16),

                // Card 3: Measurement Rejected
                _buildNotificationCard(
                  icon: Icons.cancel_rounded,
                  iconBgColor: const Color(0xFFFEE2E2),
                  iconColor: const Color(0xFFDC2626), // Alert Red
                  title: "Measurement Rejected",
                  description:
                      "Foreman Sarah rejected 'Column B-12' measurement.",
                  actionButton: PerfektButton(
                    label: "Redo",
                    onPressed: () => Get.toNamed(AppRoutes.scanning),
                  ),
                ),
                const SizedBox(height: 16),

                // Card 4: New Job Assigned
                _buildNotificationCard(
                  icon: Icons.work_outline_rounded,
                  iconBgColor: const Color(0xFFEFF6FF),
                  iconColor: PerfektTheme.primaryBlue,
                  title: "New Job Assigned",
                  description:
                      "You have been assigned to 'Skyline Apartments - Zone B'.",
                  actionButton: PerfektButton(
                    label: "Open",
                    onPressed: () => Get.toNamed(AppRoutes.jobDetails),
                  ),
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? PerfektTheme.primaryBlue
              : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: PerfektTheme.fontBold(
            13,
            color: isSelected ? Colors.white : PerfektTheme.textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String description,
    Color? accentBorderColor,
    Widget? actionButton,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: PerfektTheme.radiusCard,
        border: Border.all(color: PerfektTheme.borderLight),
        boxShadow: PerfektTheme.cardShadow,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            if (accentBorderColor != null)
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: accentBorderColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: iconBgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(icon, color: iconColor, size: 24),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              Text(
                                title,
                                style: PerfektTheme.fontBold(
                                  16,
                                  color: PerfektTheme.textDark,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                description,
                                style: PerfektTheme.fontRegular(
                                  13,
                                  color: PerfektTheme.textMedium,
                                ).copyWith(height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (actionButton != null) ...[
                      const SizedBox(height: 18),
                      SizedBox(width: double.infinity, child: actionButton),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
