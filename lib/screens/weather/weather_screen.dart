import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/weather_controller.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WeatherController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xFFF9F9FF), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 1. Custom Top Navigation Bar
              Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF9F9FF),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0D000000), // 5% opacity black
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF00418F),
                      ),
                      onPressed: () => Get.back(),
                    ),
                    const Text(
                      'PERFEKTWERK OS',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        letterSpacing: 1.2,
                        color: Color(0xFF00418F),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1E2EB),
                        border: Border.all(
                          color: const Color(0xFF0058BC),
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      // Fallback icon since the avatar asset might not be present locally
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFF00418F),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 2. Center Location Header
                        const Text(
                          'CURRENT PROJECT LOCATION',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            letterSpacing: 0.7,
                            color: Color(0xFF424753),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons
                                  .location_on_outlined, // Closer to Figma outline pin
                              color: Color(0xFF00418F),
                              size: 24,
                            ),
                            const SizedBox(width: 4),
                            Obx(
                              () => Text(
                                controller.projectLocation.value,
                                style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  color: Color(0xFF191B22),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // 3. Weather Hero Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: const Color(0x0D000000),
                              ), // rgba(0,0,0,0.05)
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x05000000),
                                  offset: Offset(0, 1),
                                  blurRadius: 1,
                                ),
                                BoxShadow(
                                  color: Color(0x0A000000),
                                  offset: Offset(0, 8),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Cloud Graphics (Layered to match image)
                                SizedBox(
                                  width: 140,
                                  height: 80,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Icon(
                                          Icons.cloud_outlined,
                                          size: 85,
                                          color: const Color(
                                            0xFFE1E2EB,
                                          ).withValues(alpha: 0.7),
                                        ),
                                      ),
                                      const Positioned(
                                        left: 0,
                                        bottom: 10,
                                        child: Icon(
                                          Icons.cloud_rounded,
                                          size: 80,
                                          color: Color(0xFF00418F),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Obx(
                                  () => Text(
                                    controller.currentTemp.value,
                                    style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 80,
                                      height: 1.0,
                                      letterSpacing: -4,
                                      color: Color(0xFF00418F),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Obx(
                                  () => Text(
                                    controller.currentCondition.value,
                                    style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Color(0xFF191B22),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Wind & Humidity Bento Boxes
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildHeroStatBox(
                                      "WIND SPEED",
                                      controller.windSpeed.value,
                                    ),
                                    const SizedBox(width: 16),
                                    _buildHeroStatBox(
                                      "HUMIDITY",
                                      controller.humidityLevel.value,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // 4. Active Site Alerts Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'ACTIVE SITE ALERTS',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                letterSpacing: 0.7,
                                color: Color(0xFF424753),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 129,
                          child: Obx(
                            () => ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.siteAlerts.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                final alert = controller.siteAlerts[index];
                                return _buildAlertCard(alert);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // 5. Hourly Timeline Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'HOURLY TIMELINE',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  letterSpacing: 0.7,
                                  color: Color(0xFF424753),
                                ),
                              ),
                              Text(
                                'NEXT 6 HOURS',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: Color(0xFF00418F),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 162,
                          child: Obx(
                            () => ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.hourlyTimeline.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final item = controller.hourlyTimeline[index];
                                return _buildHourlyCard(item);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget for the Wind/Humidity boxes
  Widget _buildHeroStatBox(String label, String value) {
    return Expanded(
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3FC),
          border: Border.all(
            color: const Color(0x4DC2C6D5),
          ), // rgba(194, 198, 213, 0.3)
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                fontSize: 10,
                color: Color(0xFF424753),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xFF00418F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for the Site Alerts
  Widget _buildAlertCard(SiteAlert alert) {
    final isCritical = alert.type == 'CRITICAL';
    final typeColor = isCritical
        ? const Color(0xFFBA1A1A)
        : const Color(0xFF5C5F61);

    return Container(
      width: 167,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x0D000000)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: typeColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                alert.type,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: typeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              alert.title,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.25,
                color: Color(0xFF191B22),
              ),
            ),
          ),
          Row(
            children: [
              Icon(alert.icon, size: 14, color: const Color(0xFF424753)),
              const SizedBox(width: 6),
              Text(
                alert.detail,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xFF424753),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Widget for the Hourly Forecast
  Widget _buildHourlyCard(HourlyForecast item) {
    return Container(
      width: 84,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: item.isRainy ? const Color(0x0D0058BC) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: item.isRainy
              ? const Color(0x3300418F)
              : const Color(0x0D000000),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            item.time,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Color(0xFF424753),
            ),
          ),
          const SizedBox(height: 12),
          Icon(
            item.icon,
            color: item.isRainy
                ? const Color(0xFF00418F)
                : const Color(0xFF424753),
            size: 26,
          ),
          const SizedBox(height: 12),
          Text(
            item.temperature,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: item.isRainy
                  ? const Color(0xFF00418F)
                  : const Color(0xFF191B22),
            ),
          ),
          if (item.humidity.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              item.humidity,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: Color(0xB300418F), // rgba(0, 65, 143, 0.7)
              ),
            ),
          ],
        ],
      ),
    );
  }
}
