import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../widgets/perfekt/perfekt_card.dart';

class LanguageSettingsController extends GetxController {
  final RxString selectedLanguage = 'English (UK)'.obs;
}

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LanguageSettingsController());

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
            'LANGUAGES',
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
                Row(
                  children: [
                    const Icon(
                      Icons.translate_rounded,
                      color: PerfektTheme.primaryBlue,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Language Selection",
                      style: PerfektTheme.fontBold(
                        20,
                        color: PerfektTheme.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                PerfektCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _buildLangOption(
                        controller,
                        "English (UK)",
                        Icons.language,
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF1F5F9),
                      ),
                      _buildLangOption(
                        controller,
                        "German (Deutsch)",
                        Icons.flag_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: PerfektButton(
                    label: "Save Changes",
                    icon: Icons.save_rounded,
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        "Language",
                        "Language set to ${controller.selectedLanguage.value}.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.white,
                        colorText: PerfektTheme.textDark,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLangOption(
    LanguageSettingsController controller,
    String lang,
    IconData icon,
  ) {
    return Obx(() {
      final isSelected = controller.selectedLanguage.value == lang;
      return InkWell(
        onTap: () => controller.selectedLanguage.value = lang,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Icon(icon, color: PerfektTheme.primaryBlue, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  lang,
                  style: PerfektTheme.fontBold(
                    16,
                    color: PerfektTheme.textDark,
                  ),
                ),
              ),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected
                    ? PerfektTheme.primaryBlue
                    : PerfektTheme.textLight,
              ),
            ],
          ),
        ),
      );
    });
  }
}
