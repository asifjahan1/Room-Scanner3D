import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';

class DevicePermissionsController extends GetxController {
  final RxBool locationServices = true.obs;
  final RxBool cameraAccess = true.obs;
  final RxBool microphone = false.obs;
}

class DevicePermissionsScreen extends StatelessWidget {
  const DevicePermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DevicePermissionsController());

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
            'PERMISSIONS',
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
                  "SYSTEM ACCESS",
                  style: PerfektTheme.fontBold(
                    11,
                    color: PerfektTheme.textLight,
                  ).copyWith(letterSpacing: 0.8),
                ),
                const SizedBox(height: 4),
                Text(
                  "Control Device\nHardware",
                  style: PerfektTheme.fontBold(
                    26,
                    color: PerfektTheme.textDark,
                  ).copyWith(height: 1.2),
                ),
                const SizedBox(height: 10),
                Text(
                  "Manage how PerfektWerk OS interacts with your device hardware to ensure safe and precise site operations.",
                  style: PerfektTheme.fontRegular(
                    14,
                    color: PerfektTheme.textMedium,
                  ).copyWith(height: 1.4),
                ),
                const SizedBox(height: 24),

                // Card 1: Location Services
                Obx(
                  () => _buildPermissionCard(
                    icon: Icons.location_on_outlined,
                    title: "Location Services",
                    description:
                        "Required for GPS site check-in, automatic blueprint alignment, and accurate LiDAR coordinate anchoring.",
                    value: controller.locationServices.value,
                    onChanged: (val) => controller.locationServices.value = val,
                  ),
                ),
                const SizedBox(height: 16),

                // Card 2: Camera Access
                Obx(
                  () => _buildPermissionCard(
                    icon: Icons.camera_alt_outlined,
                    title: "Camera Access",
                    description:
                        "Required for visual sensor scanning, structural 3D point cloud overlays, and automated safety inspections.",
                    value: controller.cameraAccess.value,
                    onChanged: (val) => controller.cameraAccess.value = val,
                  ),
                ),
                const SizedBox(height: 16),

                // Card 3: Microphone
                Obx(
                  () => _buildPermissionCard(
                    icon: Icons.mic_none_rounded,
                    title: "Microphone",
                    description:
                        "Voice dictation for field reports and acoustic status recording while wearing safety gloves.",
                    value: controller.microphone.value,
                    onChanged: (val) => controller.microphone.value = val,
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

  Widget _buildPermissionCard({
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: PerfektTheme.radiusCard,
        border: Border.all(
          color: value ? PerfektTheme.primaryBlue : PerfektTheme.borderLight,
          width: value ? 2.0 : 1.0,
        ),
        boxShadow: PerfektTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: value
                          ? const Color(0xFFEFF6FF)
                          : PerfektTheme.surfaceGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: value
                          ? PerfektTheme.primaryBlue
                          : PerfektTheme.textLight,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    title,
                    style: PerfektTheme.fontBold(
                      17,
                      color: PerfektTheme.textDark,
                    ),
                  ),
                ],
              ),
              CupertinoSwitch(
                value: value,
                activeTrackColor: PerfektTheme.primaryBlue,
                onChanged: onChanged,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            description,
            style: PerfektTheme.fontRegular(
              13,
              color: PerfektTheme.textMedium,
            ).copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }
}
