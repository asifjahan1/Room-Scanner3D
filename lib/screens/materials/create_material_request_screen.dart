import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_card.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../core/routes/app_routes.dart';

class CreateMaterialController extends GetxController {
  final RxInt quantity = 12.obs;

  void increment() => quantity.value++;
  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }
}

class CreateMaterialRequestScreen extends StatelessWidget {
  const CreateMaterialRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateMaterialController());

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
            'CREATE REQUEST',
            style: PerfektTheme.fontBold(
              16,
              color: PerfektTheme.primaryBlue,
            ).copyWith(letterSpacing: 1.0),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 22.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ITEM NAME",
                  style: PerfektTheme.fontBold(
                    11,
                    color: PerfektTheme.textLight,
                  ).copyWith(letterSpacing: 1.0),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: PerfektTheme.radiusCard,
                    border: Border.all(color: PerfektTheme.borderLight),
                    boxShadow: PerfektTheme.cardShadow,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Timber Slats 200x50",
                        style: PerfektTheme.fontBold(
                          16,
                          color: PerfektTheme.textDark,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: PerfektTheme.textLight,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Set Quantity Section
                Center(
                  child: Column(
                    children: [
                      Text(
                        "SET QUANTITY",
                        style: PerfektTheme.fontBold(
                          11,
                          color: PerfektTheme.textLight,
                        ).copyWith(letterSpacing: 1.0),
                      ),
                      const SizedBox(height: 14),
                      PerfektCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: controller.decrement,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: PerfektTheme.surfaceGrey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.remove,
                                    color: PerfektTheme.textDark,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 32),
                            Obx(
                              () => Column(
                                children: [
                                  Text(
                                    "${controller.quantity.value}",
                                    style: PerfektTheme.fontBold(
                                      36,
                                      color: PerfektTheme.primaryBlue,
                                    ),
                                  ),
                                  Text(
                                    "units",
                                    style: PerfektTheme.fontMedium(
                                      12,
                                      color: PerfektTheme.textLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 32),
                            GestureDetector(
                              onTap: controller.increment,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFBFDBFE),
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    color: PerfektTheme.primaryBlue,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Attachments Action Row
                Row(
                  children: [
                    Expanded(
                      child: _buildAttachButton(
                        icon: Icons.mic_none_rounded,
                        label: "Voice note",
                        onTap: () => Get.toNamed(AppRoutes.voiceUpdate),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildAttachButton(
                        icon: Icons.camera_alt_outlined,
                        label: "Add photo",
                        onTap: () => Get.snackbar(
                          "Camera",
                          "Stock material verification image added.",
                          snackPosition: SnackPosition.TOP,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Attached Item Thumbnail Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: PerfektTheme.radiusCard,
                    border: Border.all(color: PerfektTheme.borderLight),
                    boxShadow: PerfektTheme.cardShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?auto=format&fit=crop&q=80&w=200',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Timber framing stock",
                              style: PerfektTheme.fontBold(
                                15,
                                color: PerfektTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "2x4 Treated Pine Lumber @ Sector C",
                              style: PerfektTheme.fontRegular(
                                12,
                                color: PerfektTheme.textMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF10B981),
                        size: 22,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // Submit Primary Button
                PerfektButton(
                  label: "Submit request",
                  trailingIcon: Icons.arrow_forward_rounded,
                  height: 54,
                  fontSize: 16,
                  onPressed: () => Get.toNamed(AppRoutes.materialRequestSent),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: PerfektTheme.radiusCard,
          border: Border.all(color: PerfektTheme.borderLight),
          boxShadow: PerfektTheme.cardShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: PerfektTheme.primaryBlue, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: PerfektTheme.fontBold(14, color: PerfektTheme.textDark),
            ),
          ],
        ),
      ),
    );
  }
}
