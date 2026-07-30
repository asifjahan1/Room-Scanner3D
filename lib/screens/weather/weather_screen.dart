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
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.isError.value) {
            return Center(
              child: Text(
                "Failed to load weather data.\\nPlease check your internet connection.",
                style: PerfektTheme.fontMedium(
                  14,
                  color: PerfektTheme.textMedium,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
          return SafeArea(
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
                              child: Obx(() {
                                IconData iconData = Icons.cloud_queue_rounded;
                                final type = controller.currentIconType.value;
                                if (type == 'sun')
                                  iconData = Icons.wb_sunny_rounded;
                                if (type == 'rain')
                                  iconData = Icons.water_drop_rounded;
                                if (type == 'snow')
                                  iconData = Icons.ac_unit_rounded;
                                return Icon(
                                  iconData,
                                  size: 46,
                                  color: PerfektTheme.primaryBlue,
                                );
                              }),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                  if (controller.siteAlerts.isNotEmpty) ...[
                    Text(
                      'ACTIVE SITE ALERTS',
                      style: PerfektTheme.fontBold(
                        14,
                        color: PerfektTheme.textMedium,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: controller.siteAlerts.map((alert) {
                          final isCritical = alert.type == 'CRITICAL';
                          return Container(
                            width: 180,
                            height: 120,
                            margin: EdgeInsets.only(
                              right: alert == controller.siteAlerts.last
                                  ? 0
                                  : 12,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: PerfektTheme.cardShadow,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: isCritical
                                                ? PerfektTheme.alertCritical
                                                : PerfektTheme.textMedium,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          alert.type,
                                          style: PerfektTheme.fontMedium(
                                            12,
                                            color: isCritical
                                                ? PerfektTheme.alertCritical
                                                : PerfektTheme.textMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      alert.title,
                                      style: PerfektTheme.fontMedium(
                                        15,
                                        color: PerfektTheme.textDark,
                                      ),
                                      maxLines: 2,
                                    ),
                                    SizedBox(height: 10),

                                    Row(
                                      children: [
                                        Icon(
                                          isCritical
                                              ? Icons.air_rounded
                                              : Icons.access_time_rounded,
                                          size: 16,
                                          color: PerfektTheme.textMedium,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            alert.detail,
                                            style: PerfektTheme.fontMedium(
                                              13,
                                              color: PerfektTheme.textMedium,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  const SizedBox(height: 28),

                  // Hourly Timeline
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hourly Timeline',
                        style: PerfektTheme.fontBold(
                          18,
                          color: PerfektTheme.primaryBlue,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.show6Hours();
                        },
                        child: Obx(() {
                          return Text(
                            controller.isShowing6Hours.value ? '' : 'NEXT 6 HOURS',
                            style: PerfektTheme.fontMedium(
                              12,
                              color: PerfektTheme.primaryBlue,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.hourlyTimeline.map((item) {
                          final isNow = item.time == 'NOW';
                          return Container(
                            width: 76,
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
                              border: isNow
                                  ? null
                                  : Border.all(color: PerfektTheme.borderLight),
                              boxShadow: isNow ? PerfektTheme.cardShadow : null,
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
                                Builder(
                                  builder: (context) {
                                    IconData iData = Icons.cloud_outlined;
                                    if (item.iconType == 'sun')
                                      iData = Icons.wb_sunny_rounded;
                                    if (item.iconType == 'rain')
                                      iData = Icons.water_drop_rounded;
                                    if (item.iconType == 'snow')
                                      iData = Icons.ac_unit_rounded;

                                    return Icon(
                                      iData,
                                      color: isNow
                                          ? Colors.white
                                          : PerfektTheme.primaryBlue,
                                      size: 24,
                                    );
                                  },
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
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
