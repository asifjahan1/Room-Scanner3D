import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liddar/controllers/auth_controller.dart';

class SocialLoginSection extends StatelessWidget {
  final AuthController auth;

  const SocialLoginSection({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 46,
            child: OutlinedButton.icon(
              onPressed: auth.signInWithGoogle,
              icon: Image.asset(
                "assets/icons/google.png",
                width: 20,
                height: 20,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.g_mobiledata,
                  color: Color(0xFFEA4335),
                  size: 24,
                ),
              ),
              label: Text(
                "Google",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1C1F),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFF3F3F8),
                side: const BorderSide(color: Color(0x26C1C6D7), width: 1),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: SizedBox(
            height: 46,
            child: ElevatedButton.icon(
              onPressed: auth.signInWithApple,
              icon: const Icon(Icons.apple, color: Colors.white, size: 20),
              label: Text(
                "Apple",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1C1F),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
