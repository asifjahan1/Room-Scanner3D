import 'package:flutter/material.dart';
import 'package:liddar/theme/perfekt_theme.dart';

/////////////////////////////////////////////////

class ExpireBadge extends StatelessWidget {
  const ExpireBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xffFFEAE7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined, color: Color(0xffBA1A1A), size: 18),

          const SizedBox(width: 8),

          Text(
            "Invitation expires in 48 hours",
            style: PerfektTheme.fontSemiBold(
              13,
              color: const Color(0xffBA1A1A),
            ),
          ),
        ],
      ),
    );
  }
}
