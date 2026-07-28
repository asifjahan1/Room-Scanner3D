import 'package:flutter/material.dart';
import 'package:liddar/theme/perfekt_theme.dart';

/////////////////////////////////////////////////

class RoleCard extends StatelessWidget {
  const RoleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),

      child: Column(
        children: [
          Text(
            "ASSIGNED ROLE",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.8,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xff2563EB),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.12), blurRadius: 12),
              ],
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.engineering_outlined,
                  color: Colors.white,
                  size: 26,
                ),

                const SizedBox(width: 16),

                Text(
                  "Worker",
                  style: PerfektTheme.fontSemiBold(22, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
