import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/perfekt/perfekt_logo.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../controllers/auth_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Match the background gradient from the design
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xFFFAF8FF), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 32.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 448),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Brand Identity Header
                    const PerfektLogo(
                      subtitle: 'INDUSTRIAL INFRASTRUCTURE SYSTEMS',
                      iconSize: 64, // Updated to match Figma 64x64 container
                    ),
                    const SizedBox(height: 40),

                    // Form Section (Card removed, placed directly on background)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldTitle('FULL NAME'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: auth.fullNameController,
                          hint: 'Hans Schmidt',
                          prefixIcon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 20),

                        _buildFieldTitle('EMAIL ADDRESS'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: auth.emailController,
                          hint: 'name@company.com',
                          prefixIcon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),

                        _buildFieldTitle('PHONE NUMBER'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: auth.phoneController,
                          hint: '+49 000 000000',
                          // Using a mobile icon to better match the design's phone vector
                          prefixIcon: Icons.phone_android_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),

                        // Terms & Privacy (Microcopy)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 0.0,
                          ),
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                height: 1.25,
                                color: Color(
                                  0xCC424753,
                                ), // rgba(66, 71, 83, 0.8)
                              ),
                              children: [
                                TextSpan(
                                  text: 'By signing up, you agree to our ',
                                ),
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyle(color: Color(0xFF0058BC)),
                                ),
                                TextSpan(text: ' and\n'),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(color: Color(0xFF0058BC)),
                                ),
                                TextSpan(text: '.'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Primary Action Button
                        Obx(
                          () => PerfektButton(
                            label: auth.isLoading.value
                                ? "Signing Up..."
                                : "Sign Up",
                            trailingIcon: Icons.arrow_forward_rounded,
                            height: 64, // Updated button height to 64px
                            onPressed: () => auth.signUp(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48), // Footer Margin
                    // Secondary Action Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Color(0xFF424753),
                          ),
                        ),
                        InkWell(
                          onTap: () => auth.goToSignIn(),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Color(0xFF00418F),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to match Figma Label typography
  Widget _buildFieldTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontWeight: FontWeight.w700,
        fontSize: 14,
        letterSpacing: 0.7,
        color: Color(0xFF424753),
      ),
    );
  }

  // Helper widget to match Figma Input typography and geometry
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      height: 64, // Matched height of 64px from design
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Color(0xFF191B23), // Darker text for actual input
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color(0xFFC2C6D5),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 12.0),
            child: Icon(prefixIcon, color: const Color(0xFF727784), size: 22),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 52),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18.5,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Color(0x4DC2C6D5),
            ), // rgba(194, 198, 213, 0.3)
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0x4DC2C6D5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF0058BC), width: 1.5),
          ),
        ),
      ),
    );
  }
}
