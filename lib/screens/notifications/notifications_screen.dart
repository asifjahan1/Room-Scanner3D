import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../core/routes/app_routes.dart';

class NotificationItem {
  final int id;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String description;
  final Color? accentBorderColor;
  final String? actionLabel;
  final VoidCallback? onAction;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.description,
    this.accentBorderColor,
    this.actionLabel,
    this.onAction,
    this.isRead = false,
  });
}

class NotificationsController extends GetxController {
  final RxString selectedFilter = 'unread'.obs;

  final RxList<NotificationItem> notifications = <NotificationItem>[
    NotificationItem(
      id: 1,
      icon: Icons.assignment_turned_in_outlined,
      iconBgColor: const Color(0xFFEFF6FF),
      iconColor: PerfektTheme.primaryBlue,
      title: "Material Request Approved",
      description: "Your request for 'Premium Concrete Mix' has been approved for delivery.",
      actionLabel: "Open",
      onAction: () => Get.toNamed(AppRoutes.materialRequests),
    ),
    NotificationItem(
      id: 2,
      icon: Icons.check_circle_outline_rounded,
      iconBgColor: const Color(0xFFEFF6FF),
      iconColor: PerfektTheme.primaryBlue,
      title: "Measurement Approved",
      description: "Foreman Sarah approved 'Kitchen Wall' measurement.",
      accentBorderColor: const Color(0xFF10B981),
    ),
    NotificationItem(
      id: 3,
      icon: Icons.cancel_rounded,
      iconBgColor: const Color(0xFFFEE2E2),
      iconColor: const Color(0xFFDC2626),
      title: "Measurement Rejected",
      description: "Foreman Sarah rejected 'Column B-12' measurement.",
      actionLabel: "Redo",
      onAction: () => Get.toNamed(AppRoutes.scanning),
    ),
    NotificationItem(
      id: 4,
      icon: Icons.work_outline_rounded,
      iconBgColor: const Color(0xFFEFF6FF),
      iconColor: PerfektTheme.primaryBlue,
      title: "New Job Assigned",
      description: "You have been assigned to 'Skyline Apartments - Zone B'.",
      actionLabel: "Open",
      onAction: () => Get.toNamed(AppRoutes.jobDetails),
    ),
  ].obs;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<NotificationItem> get filteredNotifications {
    if (selectedFilter.value == 'unread') {
      return notifications.where((n) => !n.isRead).toList();
    }
    return notifications;
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  void markAllRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    selectedFilter.value = 'all'; // Switch to 'All' so they can see the faded items instead of an empty screen
    notifications.refresh();
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
                        label: "Unread (${controller.unreadCount})",
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

                // Notifications List
                Obx(() {
                  final list = controller.filteredNotifications;
                  if (list.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Text(
                          "No notifications here.",
                          style: PerfektTheme.fontMedium(15, color: PerfektTheme.textLight),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: list.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildNotificationCard(
                          icon: item.icon,
                          iconBgColor: item.iconBgColor,
                          iconColor: item.iconColor,
                          title: item.title,
                          description: item.description,
                          isRead: item.isRead,
                          accentBorderColor: item.accentBorderColor,
                          actionButton: item.actionLabel != null
                              ? PerfektButton(
                                  label: item.actionLabel!,
                                  onPressed: item.onAction ?? () {},
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  );
                }),
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
    bool isRead = false,
    Color? accentBorderColor,
    Widget? actionButton,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isRead ? const Color(0xFFF1F5F9) : Colors.white,
        borderRadius: PerfektTheme.radiusCard,
        border: Border.all(color: isRead ? Colors.transparent : PerfektTheme.borderLight),
        boxShadow: isRead ? [] : PerfektTheme.cardShadow,
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
                                  color: isRead ? PerfektTheme.textMedium : PerfektTheme.textDark,
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
