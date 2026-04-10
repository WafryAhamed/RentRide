import 'package:flutter/material.dart';

/// RentRide color palette — vibrant, modern, premium.
class AppColors {
  AppColors._();

  // ─── Primary ───
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color primaryLight = Color(0xFF64B5F6);

  // ─── Accent ───
  static const Color accent = Color(0xFFFFB300);
  static const Color accentLight = Color(0xFFFFE082);

  // ─── Gradients ───
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0A0E21), Color(0xFF1A1F38)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF1E2340), Color(0xFF141829)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Dark Theme ───
  static const Color darkBg = Color(0xFF0A0E21);
  static const Color darkSurface = Color(0xFF1A1F38);
  static const Color darkCard = Color(0xFF1E2340);
  static const Color darkCardAlt = Color(0xFF252A45);
  static const Color darkBorder = Color(0xFF2A3055);

  // ─── Light Theme ───
  static const Color lightBg = Color(0xFFF5F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE0E5EC);

  // ─── Text ───
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B8C9);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textDark = Color(0xFF1A1F38);
  static const Color textDarkSecondary = Color(0xFF6B7280);

  // ─── Status ───
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ─── Vehicle type colors ───
  static const Color bikeColor = Color(0xFF10B981);
  static const Color carColor = Color(0xFF3B82F6);
  static const Color vanColor = Color(0xFF8B5CF6);

  // ─── Rating ───
  static const Color starFilled = Color(0xFFFFB300);
  static const Color starEmpty = Color(0xFF3A3F58);

  // ─── Map ───
  static const Color mapRoute = Color(0xFF1A73E8);
  static const Color mapPickup = Color(0xFF10B981);
  static const Color mapDropoff = Color(0xFFEF4444);
}
