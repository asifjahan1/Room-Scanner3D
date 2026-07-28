import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_logo.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../widgets/perfekt/perfekt_card.dart';
import '../../controllers/auth_controller.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: PerfektTheme.backgroundLight,
      ),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 12),
                const PerfektLogo(
                  subtitle: 'INDUSTRIAL INFRASTRUCTURE SYSTEMS',
                  iconSize: 48,
                ),
                const SizedBox(height: 24),
                PerfektCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Verify Your Email",
                        style: PerfektTheme.fontBold(22, color: PerfektTheme.textDark),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "We've sent a 6-digit verification code\nto j.doe@werk-structures.com",
                        textAlign: TextAlign.center,
                        style: PerfektTheme.fontRegular(13, color: PerfektTheme.textMedium).copyWith(
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),
                      // 6-digit OTP Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) => _buildOtpBox(index == 0)),
                      ),
                      const SizedBox(height: 28),
                      // Verify Button (ZERO VALIDATION - immediately navigates)
                      Obx(() => PerfektButton(
                        label: auth.isLoading.value ? "Verifying..." : "Verify and Continue",
                        height: 50,
                        onPressed: () => auth.verifyEmail(),
                      )),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () => auth.resendCode(),
                        child: Text(
                          "Didn't receive the code? Resend code in 00:58",
                          style: PerfektTheme.fontMedium(12, color: PerfektTheme.textMedium),
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () => auth.changeEmail(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.edit_outlined, size: 14, color: PerfektTheme.primaryBlue),
                            const SizedBox(width: 4),
                            Text(
                              "Change email address",
                              style: PerfektTheme.fontSemiBold(13, color: PerfektTheme.primaryBlue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: PerfektTheme.fontRegular(14, color: PerfektTheme.textMedium),
                    ),
                    InkWell(
                      onTap: () => auth.goToSignIn(),
                      child: Text(
                        "Sign In",
                        style: PerfektTheme.fontSemiBold(14, color: PerfektTheme.primaryBlue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shield_outlined, size: 14, color: PerfektTheme.textLight),
                    const SizedBox(width: 4),
                    Text(
                      "ISO 27001   |   Vault-Shield",
                      style: PerfektTheme.fontMedium(11, color: PerfektTheme.textLight),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(bool isFocused) {
    return Container(
      width: 44,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: PerfektTheme.inputBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isFocused ? PerfektTheme.primaryBlue : PerfektTheme.borderLight,
          width: isFocused ? 2.0 : 1.0,
        ),
      ),
      child: Text(
        isFocused ? '4' : '',
        style: PerfektTheme.fontBold(20, color: PerfektTheme.textDark),
      ),
    );
  }
}
