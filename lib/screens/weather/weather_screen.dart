import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_card.dart';
import '../../controllers/weather_controller.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WeatherController());

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
              color: PerfektTheme.textDark,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Site Weather Summary',
            style: PerfektTheme.fontBold(18, color: PerfektTheme.textDark),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project Location Header
                Text(
                  'CURRENT PROJECT LOCATION',
                  style: PerfektTheme.fontSemiBold(
                    11,
                    color: PerfektTheme.textLight,
                  ).copyWith(letterSpacing: 1.2),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: PerfektTheme.primaryBlue,
                      size: 22,
                    ),
                    const SizedBox(width: 6),
                    Obx(
                      () => Text(
                        controller.projectLocation.value,
                        style: PerfektTheme.fontBold(
                          22,
                          color: PerfektTheme.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Main Weather Display Card
                PerfektCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => Text(
                                  controller.currentTemp.value,
                                  style: PerfektTheme.fontBold(
                                    56,
                                    color: PerfektTheme.textDark,
                                  ).copyWith(height: 1.0),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Obx(
                                () => Text(
                                  controller.currentCondition.value,
                                  style: PerfektTheme.fontSemiBold(
                                    18,
                                    color: PerfektTheme.textMedium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.cloud_queue_rounded,
                              size: 46,
                              color: PerfektTheme.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(color: PerfektTheme.borderLight),
                      const SizedBox(height: 16),
                      // Wind & Humidity Row
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: PerfektTheme.surfaceGrey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.air_rounded,
                                    size: 20,
                                    color: PerfektTheme.textMedium,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Wind Speed',
                                      style: PerfektTheme.fontMedium(
                                        12,
                                        color: PerfektTheme.textLight,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Obx(
                                      () => Text(
                                        controller.windSpeed.value,
                                        style: PerfektTheme.fontBold(
                                          15,
                                          color: PerfektTheme.textDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: PerfektTheme.surfaceGrey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.water_drop_outlined,
                                    size: 20,
                                    color: PerfektTheme.textMedium,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Humidity',
                                      style: PerfektTheme.fontMedium(
                                        12,
                                        color: PerfektTheme.textLight,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Obx(
                                      () => Text(
                                        controller.humidityLevel.value,
                                        style: PerfektTheme.fontBold(
                                          15,
                                          color: PerfektTheme.textDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Active Site Alerts
                Text(
                  'Active Site Alerts',
                  style: PerfektTheme.fontBold(
                    18,
                    color: PerfektTheme.textDark,
                  ),
                ),
                const SizedBox(height: 14),

                // Critical Alert Card
                PerfektCard(
                  padding: const EdgeInsets.all(18),
                  borderColor: const Color(0xFFFECACA),
                  backgroundColor: PerfektTheme.alertCriticalBg,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: PerfektTheme.alertCritical,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: PerfektTheme.alertCritical,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'CRITICAL',
                                    style: PerfektTheme.fontBold(
                                      10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'High Wind Warning',
                                  style: PerfektTheme.fontBold(
                                    15,
                                    color: PerfektTheme.textDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Gusts > 45km/h — Secure overhead crane & scaffolding.',
                              style: PerfektTheme.fontRegular(
                                13,
                                color: PerfektTheme.textMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Schedule Alert Card
                PerfektCard(
                  padding: const EdgeInsets.all(18),
                  borderColor: const Color(0xFFFED7AA),
                  backgroundColor: PerfektTheme.alertScheduleBg,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEDD5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.access_time_rounded,
                          color: PerfektTheme.alertSchedule,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: PerfektTheme.alertSchedule,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'SCHEDULE',
                                    style: PerfektTheme.fontBold(
                                      10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Pour Delayed',
                                  style: PerfektTheme.fontBold(
                                    15,
                                    color: PerfektTheme.textDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '@ < 3°C limit — Concrete thermal curing thresholds active.',
                              style: PerfektTheme.fontRegular(
                                13,
                                color: PerfektTheme.textMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Hourly Timeline
                Text(
                  'Hourly Timeline',
                  style: PerfektTheme.fontBold(
                    18,
                    color: PerfektTheme.textDark,
                  ),
                ),
                const SizedBox(height: 14),

                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: controller.hourlyTimeline.map((item) {
                      final isNow = item.time == 'NOW';
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                            right: item == controller.hourlyTimeline.last
                                ? 0
                                : 10,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isNow
                                ? PerfektTheme.primaryBlue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isNow
                                  ? PerfektTheme.primaryBlue
                                  : PerfektTheme.borderLight,
                            ),
                            boxShadow: PerfektTheme.cardShadow,
                          ),
                          child: Column(
                            children: [
                              Text(
                                item.time,
                                style: isNow
                                    ? PerfektTheme.fontBold(
                                        12,
                                        color: Colors.white,
                                      )
                                    : PerfektTheme.fontMedium(
                                        12,
                                        color: PerfektTheme.textMedium,
                                      ),
                              ),
                              const SizedBox(height: 10),
                              Icon(
                                item.iconType == 'rain'
                                    ? Icons.grain_rounded
                                    : Icons.cloud_outlined,
                                color: isNow
                                    ? Colors.white
                                    : PerfektTheme.primaryBlue,
                                size: 24,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item.temperature,
                                style: isNow
                                    ? PerfektTheme.fontBold(
                                        18,
                                        color: Colors.white,
                                      )
                                    : PerfektTheme.fontBold(
                                        18,
                                        color: PerfektTheme.textDark,
                                      ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.humidity,
                                style: isNow
                                    ? PerfektTheme.fontRegular(
                                        11,
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                      )
                                    : PerfektTheme.fontRegular(
                                        11,
                                        color: PerfektTheme.textLight,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
