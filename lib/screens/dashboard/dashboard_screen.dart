import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../controllers/dashboard_controller.dart';
import 'tabs/home_tab.dart';
import 'tabs/tasks_tab.dart';
import 'tabs/tools_tab.dart';
import 'tabs/messages_tab.dart';
import 'tabs/more_tab.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    final List<Widget> tabs = [
      const HomeTab(),
      const TasksTab(),
      const ToolsTab(),
      const MessagesTab(),
      const MoreTab(),
    ];

    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: PerfektTheme.backgroundLight,
      ),
      child: Scaffold(
        body: Obx(() => IndexedStack(
          index: controller.selectedTab.value,
          children: tabs,
        )),
        bottomNavigationBar: Obx(() => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(0, Icons.home_filled, Icons.home_outlined, 'Home', controller),
                  _buildNavItem(1, Icons.assignment_rounded, Icons.assignment_outlined, 'Task', controller),
                  _buildNavItem(2, Icons.handyman_rounded, Icons.handyman_outlined, 'Tools', controller),
                  _buildNavItem(3, Icons.chat_bubble_rounded, Icons.chat_bubble_outline_rounded, 'Message', controller),
                  _buildNavItem(4, Icons.menu_rounded, Icons.menu_rounded, 'More', controller),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label, DashboardController controller) {
    final isSelected = controller.selectedTab.value == index;

    return GestureDetector(
      onTap: () => controller.changeTab(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16.0 : 12.0,
          vertical: isSelected ? 8.0 : 6.0,
        ),
        decoration: BoxDecoration(
          color: isSelected ? PerfektTheme.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected ? [
            BoxShadow(
              color: PerfektTheme.primaryBlue.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              size: 22,
              color: isSelected ? Colors.white : PerfektTheme.textLight,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: isSelected
                  ? PerfektTheme.fontBold(11, color: Colors.white)
                  : PerfektTheme.fontMedium(11, color: PerfektTheme.textLight),
            ),
          ],
        ),
      ),
    );
  }
}
