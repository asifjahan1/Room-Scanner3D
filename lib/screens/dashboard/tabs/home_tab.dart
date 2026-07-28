import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/perfekt_theme.dart';
import '../../../widgets/perfekt/perfekt_button.dart';
import '../../../widgets/perfekt/perfekt_card.dart';
import '../../../controllers/dashboard_controller.dart';
import '../../../core/routes/app_routes.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Bar
            Row(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: PerfektTheme.primaryBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.handyman,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'PERFEKTWERK OS',
                      style: PerfektTheme.fontBold(
                        14,
                        color: PerfektTheme.textDark,
                      ).copyWith(letterSpacing: 1.0),
                    ),
                  ],
                ),
                const Spacer(),
                // Notification bell
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.notifications),
                  child: Stack(
                    children: [
                      Icon(
                        Icons.notifications_none_rounded,
                        color: PerfektTheme.textMedium,
                        size: 24,
                      ),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: PerfektTheme.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                // Profile Avatar
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: PerfektTheme.surfaceGrey,
                    border: Border.all(
                      color: PerfektTheme.primaryBlue,
                      width: 1.5,
                    ),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=250',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      size: 18,
                      color: PerfektTheme.textMedium,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Greeting & Trophy
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning, Daniel',
                      style: PerfektTheme.fontBold(
                        24,
                        color: PerfektTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Here is your day at a glance.',
                      style: PerfektTheme.fontRegular(
                        14,
                        color: PerfektTheme.textMedium,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFEF3C7)),
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: Color(0xFFD97706),
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Shift Timer Card
            PerfektCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  Text(
                    'CURRENT SHIFT SESSION',
                    style: PerfektTheme.fontSemiBold(
                      11,
                      color: PerfektTheme.textLight,
                    ).copyWith(letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Text(
                      controller.formattedTimer,
                      style: PerfektTheme.fontBold(
                        38,
                        color: PerfektTheme.textDark,
                      ).copyWith(letterSpacing: 1.0),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => Column(
                      children: [
                        Expanded(
                          child: PerfektButton(
                            label: controller.isClockedIn.value
                                ? 'CLOCK OUT'
                                : 'CLOCK IN',
                            icon: Icons.schedule_rounded,
                            height: 48,
                            backgroundColor: controller.isClockedIn.value
                                ? PerfektTheme.alertCritical
                                : PerfektTheme.primaryBlue,
                            onPressed: () => controller.toggleClockIn(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PerfektButton(
                            label: controller.isOnBreak.value
                                ? 'Resume'
                                : 'Break',
                            icon: Icons.pause_rounded,
                            type: PerfektButtonType.secondary,
                            height: 48,
                            onPressed: () => controller.toggleBreak(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Weather Card (Clickable to open Weather Screen)
            PerfektCard(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              onTap: () => controller.openWeatherScreen(),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.cloud_queue_rounded,
                      color: PerfektTheme.primaryBlue,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: PerfektTheme.fontBold(
                              15,
                              color: PerfektTheme.textDark,
                            ),
                            children: [
                              const TextSpan(text: '6°C  '),
                              TextSpan(
                                text: 'LIGHT RAIN',
                                style: PerfektTheme.fontSemiBold(
                                  13,
                                  color: PerfektTheme.textMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Site condition: Wet, slippery soil.',
                          style: PerfektTheme.fontRegular(
                            12,
                            color: PerfektTheme.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: PerfektTheme.textLight,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Today's Schedule Card
            PerfektCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 16,
                            color: PerfektTheme.primaryBlue,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "TODAY'S SCHEDULE",
                            style: PerfektTheme.fontSemiBold(
                              12,
                              color: PerfektTheme.textDark,
                            ).copyWith(letterSpacing: 0.5),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: PerfektTheme.surfaceGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Start 07:30',
                          style: PerfektTheme.fontMedium(
                            11,
                            color: PerfektTheme.textMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => controller.viewMyDay(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '4 Jobs today',
                          style: PerfektTheme.fontSemiBold(
                            15,
                            color: PerfektTheme.textDark,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: PerfektTheme.textLight,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFDBEAFE)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NEXT IMPORT',
                          style: PerfektTheme.fontSemiBold(
                            10,
                            color: PerfektTheme.primaryBlue,
                          ).copyWith(letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Zone A - Foundation Pour',
                          style: PerfektTheme.fontBold(
                            15,
                            color: PerfektTheme.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Current Progress Card
            PerfektCard(
              padding: const EdgeInsets.all(20),
              onTap: () => controller.viewMyDay(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CURRENT PROGRESS',
                        style: PerfektTheme.fontSemiBold(
                          11,
                          color: PerfektTheme.textLight,
                        ).copyWith(letterSpacing: 1.0),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: PerfektTheme.textLight,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '2 / 5 Tasks',
                        style: PerfektTheme.fontBold(
                          16,
                          color: PerfektTheme.textDark,
                        ),
                      ),
                      Text(
                        '40% Completed',
                        style: PerfektTheme.fontSemiBold(
                          14,
                          color: PerfektTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // 5-Segment Progress Bar
                  Row(
                    children: List.generate(5, (index) {
                      final isComplete = index < 2;
                      return Expanded(
                        child: Container(
                          height: 8,
                          margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                          decoration: BoxDecoration(
                            color: isComplete
                                ? PerfektTheme.primaryBlue
                                : PerfektTheme.surfaceGrey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bottom Action Buttons
            PerfektButton(
              label: 'View my day',
              trailingIcon: Icons.arrow_forward_rounded,
              height: 52,
              onPressed: () => controller.viewMyDay(),
            ),
            const SizedBox(height: 12),
            PerfektButton(
              label: 'Daily Update',
              icon: Icons.refresh_rounded,
              type: PerfektButtonType.outline,
              height: 52,
              onPressed: () => controller.triggerDailyUpdate(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
