import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liddar/screens/onboarding/widgets/company_logo.dart';
import 'package:liddar/screens/onboarding/widgets/expire_badge.dart';
import 'package:liddar/screens/onboarding/widgets/role_card.dart';

import '../../controllers/auth_controller.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_button.dart';

class InvitationScreen extends StatelessWidget {
  const InvitationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xffFAF8FF),
      body: SafeArea(
        child: Stack(
          children: [
            /// Background Grid (optional image/painter)
            // Positioned.fill(
            //   child: Opacity(
            //     opacity: .05,
            //     child: Image.asset(
            //       "assets/images/logo_on.png",
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.72),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(.55)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.08),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      /// Blue Accent
                      Container(
                        height: 8,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          gradient: LinearGradient(
                            colors: [Color(0xff004AC6), Color(0xff0058DB)],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ===========================
                      // LOGO SECTION
                      // ===========================
                      CompanyLogo(),

                      const SizedBox(height: 16),

                      Text(
                        "You've been\ninvited to join",
                        textAlign: TextAlign.center,
                        style: PerfektTheme.fontBold(
                          34,
                          color: const Color(0xff191B23),
                        ).copyWith(height: 1.18),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "SteinMetz\nConstruction",
                        textAlign: TextAlign.center,
                        style: PerfektTheme.fontBold(
                          34,
                          color: const Color(0xff004AC6),
                        ).copyWith(height: 1.18),
                      ),

                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Text(
                          "Access the centralized project management ecosystem for upcoming infrastructure and commercial developments.",
                          textAlign: TextAlign.center,
                          style: PerfektTheme.fontRegular(
                            16,
                            color: const Color(0xff434655),
                          ).copyWith(height: 1.55),
                        ),
                      ),

                      const SizedBox(height: 18),

                      /// PART-2
                      RoleCard(),

                      const SizedBox(height: 22),

                      /// PART-2
                      ExpireBadge(),

                      const SizedBox(height: 30),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: PerfektButton(
                                label: "Accept Invitation",
                                onPressed: auth.acceptInvitation,
                              ),
                            ),

                            const SizedBox(height: 16),

                            SizedBox(
                              width: double.infinity,
                              child: PerfektButton(
                                label: "Decline",
                                type: PerfektButtonType.outline,
                                onPressed: auth.declineInvitation,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
