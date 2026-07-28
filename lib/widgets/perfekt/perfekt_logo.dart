import 'package:flutter/material.dart';
import '../../theme/perfekt_theme.dart';

class PerfektLogo extends StatelessWidget {
  final String? subtitle;
  final double iconSize;
  final bool showText;

  const PerfektLogo({
    super.key,
    this.subtitle = 'INDUSTRIAL INFRASTRUCTURE SYSTEMS',
    this.iconSize = 56,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: PerfektTheme.primaryBlue,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: PerfektTheme.primaryBlue.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'T',
                  style: PerfektTheme.fontBold(iconSize * 0.45, color: Colors.white),
                ),
                Text(
                  'x',
                  style: PerfektTheme.fontBold(iconSize * 0.35, color: Colors.white.withValues(alpha: 0.95)),
                ),
              ],
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 12),
          Text(
            'PerfektWerk OS',
            style: PerfektTheme.fontBold(20, color: PerfektTheme.textDark),
          ),
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!.toUpperCase(),
              style: PerfektTheme.fontSemiBold(10, color: PerfektTheme.textLight).copyWith(
                letterSpacing: 1.2,
              ),
            ),
          ],
        ],
      ],
    );
  }
}
