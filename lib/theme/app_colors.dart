import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette (Bantuin Blue)
  static const Color primary = Color(0xFF1683FF);
  static const Color primaryDark = Color(0xFF0F6FE5);
  static const Color primaryLight = Color(0xFFEAF4FF);
  static const Color primarySoft = Color(0xFFF0F6FD);
  
  // Hero Background Gradients
  static const Color heroGradientStart = Color(0xFFDEEEFC);
  static const Color heroGradientMid = Color(0xFFE8F3FD);
  static const Color heroGradientEnd = Color(0xFFF1F7FD);

  // Status & Accents
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color successBorder = Color(0xFFA7F3D0);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color warningBorder = Color(0xFFFDE68A);

  static const Color danger = Color(0xFFEF4444);
  static const Color dangerLight = Color(0xFFFEF2F2);
  static const Color dangerBorder = Color(0xFFFECACA);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFEFF6FF);

  // Neutrals & Surfaces
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFFCBD5E1);

  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundAlt = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);

  // Rating & Favorite
  static const Color star = Color(0xFFFBBF24);
  static const Color heart = Color(0xFFEF4444);

  // Box Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x0F1683FF),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Color(0x401683FF),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];
}
