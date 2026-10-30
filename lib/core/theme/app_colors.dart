import 'package:flutter/material.dart';

/// Centralized Design Token Palette for Sakina Luxury Tactile Dark Theme.
abstract final class AppColors {
  // Foundations (OLED Pure & Slate Surfaces)
  static const Color obsidianCore     = Color(0xFF080A0C); // OLED primary background
  static const Color carbonSlate       = Color(0xFF0F1316); // Elevated card foundation
  static const Color frostedGlass      = Color(0x66151A21); // 40% translucent surface
  static const Color surfaceElevated   = Color(0xFF1E242B); // Secondary elevated surface
  static const Color cardShadow        = Color(0x66000000); // 40% pitch black shadow

  // Sacred Metallic Gold Accents
  static const Color champagneGold     = Color(0xFFD4AF37); // Primary sacred accents & icons
  static const Color paleRadiance       = Color(0xFFF3E5AB); // Soft luminescent highlights
  static const Color goldBorderStroke   = Color(0x33D4AF37); // 20% opacity 1px hairline stroke
  static const Color goldGlowSoft       = Color(0x1AD4AF37); // 10% opacity radiant aura

  // Spiritual Emerald (Serenity, Healing, Streaks)
  static const Color emeraldGlow       = Color(0xFF10B981); // Serenity, bookmarks, progress
  static const Color deepSanctuary     = Color(0xFF0B3B2C); // Background spiritual tint

  // High-Contrast Typography
  static const Color pureChalk         = Color(0xFFF8FAFC); // High contrast Quranic text
  static const Color mutedSilver       = Color(0xFF94A3B8); // Metadata, translations, timestamps
  static const Color softAmber         = Color(0xFFFBBF24); // Warm bookmark indicators
  static const Color errorRed          = Color(0xFFEF4444); // Error state indicator
}

