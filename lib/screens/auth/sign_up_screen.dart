import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_logo.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../widgets/perfekt/perfekt_card.dart';
import '../../controllers/auth_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
                const SizedBox(height: 8),
                const PerfektLogo(
                  subtitle: 'INDUSTRIAL INFRASTRUCTURE SYSTEMS',
                  iconSize: 48,
                ),
                const SizedBox(height: 24),
                PerfektCard(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldTitle('FULL NAME'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: auth.fullNameController,
                        style: PerfektTheme.fontMedium(15, color: PerfektTheme.textDark),
                        decoration: _inputDecoration(
                          hint: 'Hans Schmidt',
                          prefixIcon: Icons.person_outline_rounded,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildFieldTitle('EMAIL ADDRESS'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: auth.emailController,
                        style: PerfektTheme.fontMedium(15, color: PerfektTheme.textDark),
                        decoration: _inputDecoration(
                          hint: 'name@company.com',
                          prefixIcon: Icons.mail_outline_rounded,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildFieldTitle('PHONE NUMBER'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: auth.phoneController,
                        style: PerfektTheme.fontMedium(15, color: PerfektTheme.textDark),
                        decoration: _inputDecoration(
                          hint: '+49 000 0000000',
                          prefixIcon: Icons.phone_outlined,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        "By signing up, you agree to our Terms of Service and Privacy Policy.",
                        style: PerfektTheme.fontRegular(12, color: PerfektTheme.textLight).copyWith(
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 22),
                      // Sign Up Button (ABSOLUTELY ZERO VALIDATION)
                      Obx(() => PerfektButton(
                        label: auth.isLoading.value ? "Signing Up..." : "Sign Up",
                        trailingIcon: Icons.arrow_forward_rounded,
                        height: 50,
                        onPressed: () => auth.signUp(),
                      )),
                      const SizedBox(height: 16),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: PerfektTheme.fontRegular(13, color: PerfektTheme.textMedium),
                            ),
                            InkWell(
                              onTap: () => auth.goToSignIn(),
                              child: Text(
                                "Sign In",
                                style: PerfektTheme.fontSemiBold(13, color: PerfektTheme.primaryBlue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldTitle(String title) {
    return Text(
      title,
      style: PerfektTheme.fontSemiBold(11, color: PerfektTheme.textMedium).copyWith(
        letterSpacing: 0.8,
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: PerfektTheme.fontRegular(14, color: PerfektTheme.textLight),
      filled: true,
      fillColor: PerfektTheme.inputBackground,
      prefixIcon: Icon(prefixIcon, color: PerfektTheme.textLight, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: PerfektTheme.radiusInput,
        borderSide: const BorderSide(color: PerfektTheme.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: PerfektTheme.radiusInput,
        borderSide: const BorderSide(color: PerfektTheme.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: PerfektTheme.radiusInput,
        borderSide: const BorderSide(color: PerfektTheme.borderFocus, width: 1.5),
      ),
    );
  }
}
