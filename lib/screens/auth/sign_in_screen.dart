import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_logo.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../widgets/perfekt/perfekt_card.dart';
import '../../controllers/auth_controller.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 12),
                const PerfektLogo(
                  subtitle: 'INDUSTRIAL INFRASTRUCTURE SYSTEMS',
                  iconSize: 52,
                ),
                const SizedBox(height: 28),
                PerfektCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sign In",
                        style: PerfektTheme.fontBold(22, color: PerfektTheme.textDark),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Access your high-precision workspace.",
                        style: PerfektTheme.fontRegular(14, color: PerfektTheme.textMedium),
                      ),
                      const SizedBox(height: 24),
                      // Email Field (No validation)
                      TextField(
                        controller: auth.emailController,
                        style: PerfektTheme.fontMedium(15, color: PerfektTheme.textDark),
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                          hintStyle: PerfektTheme.fontRegular(14, color: PerfektTheme.textLight),
                          filled: true,
                          fillColor: PerfektTheme.inputBackground,
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
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Password Field (No validation)
                      TextField(
                        controller: auth.passwordController,
                        obscureText: true,
                        style: PerfektTheme.fontMedium(15, color: PerfektTheme.textDark),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: PerfektTheme.fontRegular(14, color: PerfektTheme.textLight),
                          filled: true,
                          fillColor: PerfektTheme.inputBackground,
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
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => InkWell(
                            onTap: () => auth.toggleRememberMe(!auth.rememberMe.value),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: auth.rememberMe.value,
                                    onChanged: auth.toggleRememberMe,
                                    activeColor: PerfektTheme.primaryBlue,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Remember me",
                                  style: PerfektTheme.fontMedium(13, color: PerfektTheme.textMedium),
                                ),
                              ],
                            ),
                          )),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              "Forgot password?",
                              style: PerfektTheme.fontSemiBold(13, color: PerfektTheme.primaryBlue),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Sign In Button (Strictly ZERO validation)
                      Obx(() => PerfektButton(
                        label: auth.isLoading.value ? "Signing in..." : "Sign In",
                        height: 50,
                        onPressed: () => auth.signIn(),
                      )),
                      const SizedBox(height: 24),
                      // Divider OR
                      Row(
                        children: [
                          const Expanded(child: Divider(color: PerfektTheme.borderLight)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "OR",
                              style: PerfektTheme.fontSemiBold(11, color: PerfektTheme.textLight),
                            ),
                          ),
                          const Expanded(child: Divider(color: PerfektTheme.borderLight)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Social Sign in buttons
                      Row(
                        children: [
                          Expanded(
                            child: PerfektButton(
                              label: "Google",
                              icon: Icons.g_mobiledata_rounded,
                              type: PerfektButtonType.outline,
                              height: 46,
                              fontSize: 14,
                              onPressed: () => auth.signInWithGoogle(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PerfektButton(
                              label: "Apple",
                              icon: Icons.apple,
                              type: PerfektButtonType.outline,
                              height: 46,
                              fontSize: 14,
                              onPressed: () => auth.signInWithApple(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                // Footer link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "New Here? ",
                      style: PerfektTheme.fontRegular(14, color: PerfektTheme.textMedium),
                    ),
                    InkWell(
                      onTap: () => auth.goToSignUp(),
                      child: Text(
                        "Sign Up",
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
}
