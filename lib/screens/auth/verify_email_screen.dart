import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../widgets/perfekt/perfekt_logo.dart';
import '../../controllers/auth_controller.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Background Gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xFFFAF8FF), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 48.0,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 448),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const PerfektLogo(
                      subtitle: 'INDUSTRIAL INFRASTRUCTURE SYSTEMS',
                      iconSize: 64, // Matched with earlier size
                    ),
                    const SizedBox(height: 40),

                    // Verification Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFC3C6D7)),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            offset: Offset(0, 1),
                            blurRadius: 1,
                          ),
                          BoxShadow(
                            color: Color(0x0D000000),
                            offset: Offset(0, 4),
                            blurRadius: 6,
                          ),
                          BoxShadow(
                            color: Color(0x0D000000),
                            offset: Offset(0, 12),
                            blurRadius: 24,
                          ),
                          BoxShadow(
                            color: Color(0x0D000000),
                            offset: Offset(0, 24),
                            blurRadius: 48,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Verify Your Email",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              height: 1.33,
                              letterSpacing: -0.6,
                              color: Color(0xFF191B23),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "We've sent a 6-digit verification code\nto j.doe@werk-structures.com",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              height: 1.62,
                              color: Color(0xFF434655),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // 6-digit OTP Row (Updated to actual input fields)
                          const OtpInputGroup(),

                          const SizedBox(height: 32),

                          // Verify Button
                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0058BC),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () => auth.verifyEmail(),
                                child: Text(
                                  auth.isLoading.value
                                      ? "Verifying..."
                                      : "Verify and Continue",
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Footer - Secondary Actions
                          Column(
                            children: [
                              const Text(
                                "Didn't receive the code?",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Color(0xFF434655),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // আগের static InkWell-এর জায়গায় এই কোডটি বসান:
                              Obx(
                                () => InkWell(
                                  // canResend true হলে onTap কাজ করবে, অন্যথায় null (disable) থাকবে
                                  onTap: auth.canResend.value
                                      ? () => auth.resendCode()
                                      : null,
                                  child: Text(
                                    auth.canResend.value
                                        ? "Resend code"
                                        : "Resend code in 00:${auth.secondsRemaining.value.toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      // ক্লিকেবল হলে ব্লু কালার হবে, না হলে আগের গ্রে কালার থাকবে
                                      color: auth.canResend.value
                                          ? const Color(0xFF0058BC)
                                          : const Color(0xFF737686),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              InkWell(
                                onTap: () => auth.changeEmail(),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.edit_outlined,
                                      size: 16,
                                      color: Color(0xFF434655),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "Change email address",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Color(0xFF434655),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Bottom Footer Links & Badges
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xFF434655),
                          ),
                        ),
                        InkWell(
                          onTap: () => auth.goToSignIn(),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFF0058BC), // Typical link blue
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildBadge(Icons.shield_outlined, "ISO 27001"),
                        const SizedBox(width: 32),
                        _buildBadge(Icons.cloud_outlined, "Real-time"),
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

  Widget _buildBadge(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: const Color(0x99737686),
        ), // rgba(115, 118, 134, 0.6)
        const SizedBox(width: 6),
        Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 12,
            letterSpacing: 0.6,
            color: Color(0x99737686),
          ),
        ),
      ],
    );
  }
}

// Stateful Widget to manage OTP Focus and input changes
class OtpInputGroup extends StatefulWidget {
  const OtpInputGroup({super.key});

  @override
  State<OtpInputGroup> createState() => _OtpInputGroupState();
}

class _OtpInputGroupState extends State<OtpInputGroup> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(6, (index) => FocusNode());
    _controllers = List.generate(6, (index) => TextEditingController());

    // Update the UI when a field gets or loses focus
    for (int i = 0; i < 6; i++) {
      _focusNodes[i].addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        final isFocused = _focusNodes[index].hasFocus;

        return Container(
          width: 46, // Adjusted slightly to fit small screens
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFAF8FF),
            borderRadius: BorderRadius.circular(12),
            border: isFocused
                ? const Border(
                    top: BorderSide(color: Color(0xFF2563EB), width: 1),
                    left: BorderSide(color: Color(0xFF2563EB), width: 1),
                    right: BorderSide(color: Color(0xFF2563EB), width: 1),
                    bottom: BorderSide(color: Color(0xFF2563EB), width: 3),
                  )
                : Border.all(color: const Color(0xFFC3C6D7), width: 1),
            boxShadow: isFocused
                ? [
                    const BoxShadow(
                      color: Color(0xFF2563EB),
                      blurRadius: 0,
                      spreadRadius: 0,
                    ),
                  ]
                : [
                    const BoxShadow(
                      color: Color(0x1A000000), // rgba(0,0,0,0.1)
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
          ),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 1,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Color(0xFF191B23),
            ),
            decoration: const InputDecoration(
              counterText: "", // Hide the character limit counter
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) {
              // Focus logic
              if (value.isNotEmpty && index < 5) {
                _focusNodes[index + 1].requestFocus();
              } else if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
            },
          ),
        );
      }),
    );
  }
}
