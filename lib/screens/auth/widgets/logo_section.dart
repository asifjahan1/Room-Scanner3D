import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF0058BC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 15,
                    offset: Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  "assets/images/welcome_logo.png",
                  width: 34,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.architecture,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Text(
          "PerfektWerk OS",
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 32 / 24,
            letterSpacing: -0.6,
            color: const Color(0xFF191B23),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          "INDUSTRIAL INFRASTRUCTURE SYSTEMS",
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            height: 15 / 10,
            letterSpacing: 1.0,
            color: const Color(0xCC434655),
          ),
        ),
      ],
    );
  }
}
