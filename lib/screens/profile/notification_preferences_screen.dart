import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_card.dart';

class NotificationPreferencesController extends GetxController {
  final RxBool pushNotifications = true.obs;
  final RxBool taskUpdates = true.obs;
  final RxBool measurementStatus = true.obs;
}

class NotificationPreferencesScreen extends StatelessWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationPreferencesController());

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
            'NOTIFICATION SETTING',
            style: PerfektTheme.fontBold(
              16,
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
                Text(
                  "Notification Preferences",
                  style: PerfektTheme.fontBold(
                    22,
                    color: PerfektTheme.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Configure real-time site dispatch alerts and push channels.",
                  style: PerfektTheme.fontRegular(
                    14,
                    color: PerfektTheme.textMedium,
                  ),
                ),
                const SizedBox(height: 26),

                // Primary Channels
                Text(
                  "PRIMARY CHANNELS",
                  style: PerfektTheme.fontBold(
                    12,
                    color: PerfektTheme.textLight,
                  ).copyWith(letterSpacing: 0.8),
                ),
                const SizedBox(height: 10),
                PerfektCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Push Notifications",
                          style: PerfektTheme.fontBold(
                            16,
                            color: PerfektTheme.textDark,
                          ),
                        ),
                        CupertinoSwitch(
                          value: controller.pushNotifications.value,
                          activeTrackColor: PerfektTheme.primaryBlue,
                          onChanged: (val) =>
                              controller.pushNotifications.value = val,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Operational Alerts
                Text(
                  "OPERATIONAL ALERTS",
                  style: PerfektTheme.fontBold(
                    12,
                    color: PerfektTheme.textLight,
                  ).copyWith(letterSpacing: 0.8),
                ),
                const SizedBox(height: 10),
                PerfektCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Task Updates",
                                      style: PerfektTheme.fontBold(
                                        16,
                                        color: PerfektTheme.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Assigned, progress, or completed",
                                      style: PerfektTheme.fontRegular(
                                        12,
                                        color: PerfektTheme.textMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CupertinoSwitch(
                                value: controller.taskUpdates.value,
                                activeTrackColor: PerfektTheme.primaryBlue,
                                onChanged: (val) =>
                                    controller.taskUpdates.value = val,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF1F5F9),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Measurement Status",
                                      style: PerfektTheme.fontBold(
                                        16,
                                        color: PerfektTheme.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Approved or rejected by foreman",
                                      style: PerfektTheme.fontRegular(
                                        12,
                                        color: PerfektTheme.textMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CupertinoSwitch(
                                value: controller.measurementStatus.value,
                                activeTrackColor: PerfektTheme.primaryBlue,
                                onChanged: (val) =>
                                    controller.measurementStatus.value = val,
                              ),
                            ],
                          ),
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
    );
  }
}
