import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/perfekt_theme.dart';
import '../../widgets/perfekt/perfekt_logo.dart';
import '../../widgets/perfekt/perfekt_button.dart';
import '../../controllers/auth_controller.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: PerfektTheme.backgroundLight,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Subtle blueprint / technical background pattern illustration
              Positioned.fill(
                child: CustomPaint(painter: _GridPatternPainter()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28.0,
                  vertical: 24.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    // Centered Logo and subtitle
                    const Center(
                      child: PerfektLogo(
                        subtitle: 'PREPARING YOUR WORKSPACE',
                        iconSize: 64,
                      ),
                    ),
                    const SizedBox(height: 56),
                    // Large Impactful Title with highlighted span
                    RichText(
                      text: TextSpan(
                        style: PerfektTheme.fontBold(
                          34,
                          color: PerfektTheme.textDark,
                        ).copyWith(height: 1.15),
                        children: [
                          const TextSpan(text: 'Run every job\nwith '),
                          TextSpan(
                            text: 'precision',
                            style: PerfektTheme.fontBold(
                              34,
                              color: PerfektTheme.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'The definitive construction management platform for high-performance engineering teams. Streamline operations from jobsite to office with digital craftsmanship.',
                      style: PerfektTheme.fontRegular(
                        15,
                        color: PerfektTheme.textMedium,
                      ).copyWith(height: 1.5),
                    ),
                    const Spacer(),
                    // Primary Get Started button
                    PerfektButton(
                      label: 'Get Started',
                      trailingIcon: Icons.arrow_forward_rounded,
                      height: 56,
                      fontSize: 17,
                      onPressed: () => auth.goToInvitation(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Draws subtle technical construction grid lines for high-precision aesthetic
class _GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0F172A).withValues(alpha: 0.03)
      ..strokeWidth = 1.0;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
