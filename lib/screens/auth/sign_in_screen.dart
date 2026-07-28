import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liddar/screens/auth/widgets/blueprint_background.dart';
import 'package:liddar/screens/auth/widgets/logo_section.dart';
import 'package:liddar/screens/auth/widgets/security_footer.dart';
import 'package:liddar/screens/auth/widgets/signIn_fields.dart';
import 'package:liddar/screens/auth/widgets/social_login_section.dart';

import '../../controllers/auth_controller.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          const Positioned.fill(
            child: Opacity(opacity: 0.3, child: BlueprintBackground()),
          ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 512),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      const LogoSection(),

                      const SizedBox(height: 32),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xCCE2E8F0),
                            width: 1,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 6,
                              offset: Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Color(0x1A000000),
                              blurRadius: 15,
                              offset: Offset(0, 10),
                            ),
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 25,
                              offset: Offset(0, 20),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sign In",
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                height: 28 / 20,
                                color: const Color(0xFF191B23),
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "Access your high-precision workspace.",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                height: 20 / 14,
                                color: const Color(0xFF434655),
                              ),
                            ),

                            const SizedBox(height: 24),

                            SignInFields(auth: auth),

                            const SizedBox(height: 16),

                            SocialLoginSection(auth: auth),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "New Here? ",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 24 / 16,
                              color: const Color(0xFF434655),
                            ),
                          ),
                          GestureDetector(
                            onTap: auth.goToSignUp,
                            child: Text(
                              "Sign Up",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 24 / 16,
                                color: const Color(0xFF0058BC),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const SecurityFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
