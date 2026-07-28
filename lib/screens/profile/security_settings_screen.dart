import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../widgets/perfekt/perfekt_card.dart';

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPassController = TextEditingController(text: "••••••••");
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();

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
            'SECURITY',
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
                      Icons.lock_outline_rounded,
                      color: PerfektTheme.primaryBlue,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Change Password",
                      style: PerfektTheme.fontBold(
                        20,
                        color: PerfektTheme.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                PerfektCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPasswordField(
                        "Current Password",
                        currentPassController,
                        obscure: true,
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordField(
                        "New Password",
                        newPassController,
                        hint: "Enter new password",
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordField(
                        "Confirm New Password",
                        confirmPassController,
                        hint: "Confirm new password",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: PerfektButton(
                    label: "Save Changes",
                    icon: Icons.save_rounded,
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        "Security",
                        "Password updated successfully.",
                        snackPosition: SnackPosition.TOP,
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

  Widget _buildPasswordField(
    String label,
    TextEditingController controller, {
    bool obscure = true,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: PerfektTheme.fontMedium(13, color: PerfektTheme.textDark),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: PerfektTheme.fontRegular(15, color: PerfektTheme.textDark),
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: PerfektTheme.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: PerfektTheme.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: PerfektTheme.primaryBlue,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
