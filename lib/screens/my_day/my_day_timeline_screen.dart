import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_card.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../core/routes/app_routes.dart';

class MyDayTimelineScreen extends StatelessWidget {
  const MyDayTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: PerfektTheme.backgroundLight,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: PerfektTheme.textDark, size: 20),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'PLANS',
            style: PerfektTheme.fontBold(18, color: PerfektTheme.textDark).copyWith(
              letterSpacing: 1.2,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PerfektTheme.surfaceGrey,
                  border: Border.all(color: PerfektTheme.primaryBlue, width: 1.5),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=250'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              children: [
                _buildTimelineItem(
                  time: "07:30",
                  title: "Travel to site",
                  subtitle: "Zone A",
                  status: "DONE",
                  statusColor: PerfektTheme.successGreen,
                  statusBg: PerfektTheme.successGreenBg,
                  nodeWidget: _buildNodeIcon(Icons.check_circle, PerfektTheme.successGreen, isFilled: true),
                  isLast: false,
                ),
                _buildTimelineItem(
                  time: "08:00",
                  title: "Install wall framing",
                  subtitle: "Main Hall",
                  status: "LIVE",
                  statusColor: Colors.white,
                  statusBg: PerfektTheme.primaryBlue,
                  nodeWidget: _buildNodeIcon(Icons.engineering_rounded, PerfektTheme.primaryBlue, isLarge: true),
                  isActiveCard: true,
                  isLast: false,
                  actionWidget: Column(
                    children: [
                      const SizedBox(height: 16),
                      PerfektButton(
                        label: "Open Next Task",
                        trailingIcon: Icons.arrow_forward_rounded,
                        height: 46,
                        fontSize: 14,
                        onPressed: () => Get.toNamed(AppRoutes.taskDetail),
                      ),
                    ],
                  ),
                ),
                _buildTimelineItem(
                  time: "11:30",
                  title: "Measure kitchen wall",
                  subtitle: "Kitchen B",
                  status: "UPCOMING",
                  statusColor: PerfektTheme.textMedium,
                  statusBg: PerfektTheme.surfaceGrey,
                  nodeWidget: _buildNodeIcon(Icons.schedule_rounded, PerfektTheme.textLight),
                  isLast: false,
                  trailingIcon: Icons.qr_code_scanner_rounded,
                ),
                _buildTimelineItem(
                  time: "14:00",
                  title: "Progress update",
                  subtitle: "Site-wide",
                  nodeWidget: _buildNodeIcon(Icons.assignment_turned_in_outlined, PerfektTheme.textLight),
                  isLast: true,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNodeIcon(IconData icon, Color color, {bool isFilled = false, bool isLarge = false}) {
    if (isLarge) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      );
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isFilled ? Colors.white : PerfektTheme.surfaceGrey,
        shape: BoxShape.circle,
        border: Border.all(color: isFilled ? color : PerfektTheme.borderLight, width: isFilled ? 0 : 1.5),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }

  Widget _buildTimelineItem({
    required String time,
    required String title,
    required String subtitle,
    String? status,
    Color? statusColor,
    Color? statusBg,
    required Widget nodeWidget,
    required bool isLast,
    bool isActiveCard = false,
    Widget? actionWidget,
    IconData? trailingIcon,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Node and Connecting Line
          SizedBox(
            width: 46,
            child: Column(
              children: [
                nodeWidget,
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: PerfektTheme.borderLight,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: PerfektCard(
                padding: const EdgeInsets.all(18),
                borderColor: isActiveCard ? PerfektTheme.primaryBlue : PerfektTheme.borderLight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          time,
                          style: PerfektTheme.fontBold(13, color: isActiveCard ? PerfektTheme.primaryBlue : PerfektTheme.textDark),
                        ),
                        if (status != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusBg ?? PerfektTheme.surfaceGrey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status,
                              style: PerfektTheme.fontBold(10, color: statusColor ?? PerfektTheme.textMedium).copyWith(
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: PerfektTheme.fontBold(17, color: PerfektTheme.textDark),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 14, color: PerfektTheme.textLight),
                            const SizedBox(width: 4),
                            Text(
                              subtitle,
                              style: PerfektTheme.fontRegular(13, color: PerfektTheme.textMedium),
                            ),
                          ],
                        ),
                        if (trailingIcon != null)
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: PerfektTheme.surfaceGrey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(trailingIcon, size: 18, color: PerfektTheme.textMedium),
                          ),
                      ],
                    ),
                    ?actionWidget,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
