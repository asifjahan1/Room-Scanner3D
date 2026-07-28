import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Clean and modern design tokens for PerfektWerk OS high-precision construction platform.
class PerfektTheme {
  // Brand & Palette Colors
  static const Color primaryBlue = Color(0xFF155DFC);
  static const Color primaryBlueDark = Color(0xFF0C4BCE);
  static const Color primaryBlueLight = Color(0xFFD3E4FF);
  
  static const Color backgroundLight = Color(0xFFF9FAFC);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceGrey = Color(0xFFF1F5F9);
  static const Color surfaceDarkGrey = Color(0xFF334155);
  static const Color inputBackground = Color(0xFFF8FAFC);

  // Text Colors
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMedium = Color(0xFF475569);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Borders & Accents
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderFocus = Color(0xFF3B82F6);
  
  // Alert Colors
  static const Color alertCritical = Color(0xFFDC2626);
  static const Color alertCriticalBg = Color(0xFFFEF2F2);
  static const Color alertSchedule = Color(0xFFF97316);
  static const Color alertScheduleBg = Color(0xFFFFF7ED);
  static const Color successGreen = Color(0xFF16A34A);
  static const Color successGreenBg = Color(0xFFF0FDF4);

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.02),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: primaryBlue.withValues(alpha: 0.25),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  // Border Radiuses
  static final BorderRadius radiusCard = BorderRadius.circular(16);
  static final BorderRadius radiusButton = BorderRadius.circular(12);
  static final BorderRadius radiusInput = BorderRadius.circular(12);
  static final BorderRadius radiusPill = BorderRadius.circular(999);

  // Typography helpers with zero-lag system fallbacks
  static TextStyle fontBold(double size, {Color color = textDark}) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
      letterSpacing: -0.5,
    ).copyWith(
      fontFamilyFallback: const ['sans-serif', 'Helvetica', 'Arial'],
    );
  }

  static TextStyle fontSemiBold(double size, {Color color = textDark}) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: -0.3,
    ).copyWith(
      fontFamilyFallback: const ['sans-serif', 'Helvetica', 'Arial'],
    );
  }

  static TextStyle fontMedium(double size, {Color color = textMedium}) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w500,
      color: color,
    ).copyWith(
      fontFamilyFallback: const ['sans-serif', 'Helvetica', 'Arial'],
    );
  }

  static TextStyle fontRegular(double size, {Color color = textMedium}) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color,
    ).copyWith(
      fontFamilyFallback: const ['sans-serif', 'Helvetica', 'Arial'],
    );
  }
}
