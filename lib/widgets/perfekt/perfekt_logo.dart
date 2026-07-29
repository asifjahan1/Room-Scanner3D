import 'package:flutter/material.dart';
import '../../theme/perfekt_theme.dart';

class PerfektLogo extends StatelessWidget {
  final String? subtitle;
  final double iconSize;
  final bool showText;

  const PerfektLogo({
    super.key,
    this.subtitle = 'INDUSTRIAL INFRASTRUCTURE SYSTEMS',
    this.iconSize =
        64, // Updated default size to 64 based on the previous Figma design
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Replaced the blue container with the requested image asset
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 10),
                spreadRadius: -3,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/welcome_logo.png',
              width: iconSize,
              height: iconSize,
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 16),
          Text(
            'PerfektWerk OS',
            style: PerfektTheme.fontBold(
              24,
              color: PerfektTheme.textDark,
            ), // Updated to match 24px heading
          ),
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!.toUpperCase(),
              style: PerfektTheme.fontSemiBold(
                10,
                color: PerfektTheme.textLight,
              ).copyWith(letterSpacing: 1.0),
            ),
          ],
        ],
      ],
    );
  }
}
