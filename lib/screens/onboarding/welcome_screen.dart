import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xffFAF8FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 36),

              /// Logo
              Image.asset(
                "assets/images/welcome_logo.png",
                width: 128,
                fit: BoxFit.contain,
              ),

              // const PerfektLogo(
              //   iconSize: 128,
              // ),
              const SizedBox(height: 18),

              /// App Name
              Text(
                "PerfektWerk OS",
                style: PerfektTheme.fontSemiBold(
                  24,
                  color: const Color(0xff191B23),
                ),
              ),

              const SizedBox(height: 52),

              /// Progress Line
              Container(
                width: 240,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xffC3C6D7),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                "PREPARING YOUR WORKSPACE",
                style: PerfektTheme.fontSemiBold(
                  12,
                  color: const Color(0xff666B7A),
                ).copyWith(letterSpacing: 1.8),
              ),

              const SizedBox(height: 48),

              /// Heading
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: PerfektTheme.fontBold(
                    48,
                    color: const Color(0xff191B23),
                  ).copyWith(height: 1.12),
                  children: [
                    const TextSpan(text: "Run every job\nwith "),
                    TextSpan(
                      text: "precision",
                      style: PerfektTheme.fontBold(
                        48,
                        color: const Color(0xff0058BC),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: 340,
                child: Text(
                  "The definitive construction management platform for high-performance engineering teams. Streamline operations from jobsite to office with digital craftsmanship.",
                  textAlign: TextAlign.center,
                  style: PerfektTheme.fontRegular(
                    18,
                    color: const Color(0xff434655),
                  ).copyWith(height: 1.55),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: PerfektButton(
                  label: "Get Started",
                  fontSize: 16,
                  height: 56,
                  trailingIcon: Icons.arrow_forward_rounded,
                  onPressed: auth.goToInvitation,
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
