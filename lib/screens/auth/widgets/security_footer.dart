import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityFooter extends StatelessWidget {
  const SecurityFooter({super.key});

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0x99737686);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shield_outlined,
              color: textColor,
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              "ISO 27001",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
                color: textColor,
              ),
            ),
          ],
        ),

        const SizedBox(width: 32),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_outlined,
              color: textColor,
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              "Real-time",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
                color: textColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

