import 'package:flutter/material.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';

/// Centralized Design Token Palette for Sakina Luxury Sanctuary.
/// Supports 4 dedicated tactile atmospheric themes:
/// 1. Modern Charcoal Slate (`charcoalCore` - Primary default theme from user specification)
/// 2. Tactile OLED Dark Theme (`obsidianCore` foundation with Champagne Gold)
/// 3. Calming Sacred Parchment Light Theme (`parchmentCore` - soothing cream paper)
/// 4. Royal Emerald Sanctuary (`emeraldSanctuaryCore` - chic regal forest serenity)
abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // ---------------------------------------------------------------------------
  // 1. Modern Charcoal Slate Foundations (User-Specified Primary Default Theme)
  // Deep, dark, velvety charcoal tones (zero washed-out gray)
  // ---------------------------------------------------------------------------
  static const Color charcoalCore = Color(
    0xFF0C0D0F,
  ); // Deep modern dark charcoal background
  static const Color charcoalCard = Color(
    0xFF16171A,
  ); // Velvety dark graphite card surface
  static const Color charcoalElevated = Color(
    0xFF1F2024,
  ); // Refined dark pill buttons & secondary surface
  static const Color charcoalBorder = Color(
    0xFF28292E,
  ); // Subtle dark hairline divider
  static const Color charcoalGlass = Color(
    0xCC16171A,
  ); // Translucent charcoal glass
  static const Color charcoalMuted = Color(
    0xFF7E808A,
  ); // Muted cool silver-gray metadata
  static const Color charcoalAccent = Color(
    0xFFDCDCE2,
  ); // Crisp platinum metallic accent

  // ---------------------------------------------------------------------------
  // 2. Dark Theme Foundations (OLED Pure & Slate Surfaces)
  // ---------------------------------------------------------------------------
  static const Color obsidianCore = Color(
    0xFF080A0C,
  ); // OLED primary background
  static const Color carbonSlate = Color(
    0xFF0F1316,
  ); // Elevated card foundation
  static const Color frostedGlass = Color(
    0x66151A21,
  ); // 40% translucent surface
  static const Color surfaceElevated = Color(
    0xFF1E242B,
  ); // Secondary elevated surface
  static const Color cardShadow = Color(0x66000000); // 40% pitch black shadow

  // ---------------------------------------------------------------------------
  // 3. Light Theme Foundations (Calming Sacred Parchment & Cream Surfaces)
  // Extracted directly from user-approved soothing paper canvas
  // ---------------------------------------------------------------------------
  static const Color parchmentCore = Color(
    0xFFF6EDE2,
  ); // Soothing primary paper background
  static const Color parchmentCard = Color(
    0xFFEDE6D7,
  ); // Elevated warm cream card foundation
  static const Color parchmentElevated = Color(
    0xFFE2DACB,
  ); // Secondary elevated cream surface
  static const Color parchmentBorder = Color(
    0xFFD7D1C3,
  ); // Soft warm hairline divider stroke
  static const Color parchmentGlass = Color(
    0xCCEDE6D7,
  ); // 80% translucent cream surface
  static const Color inkDeep = Color(
    0xFF241E19,
  ); // High-contrast, restful deep umber text
  static const Color inkMuted = Color(
    0xFF766C62,
  ); // Muted slate umber for captions & metadata
  static const Color warmGold = Color(
    0xFFB88E28,
  ); // Calibrated antique sacred gold on light
  static const Color forestEmerald = Color(
    0xFF1B6A50,
  ); // Calibrated deep forest emerald on light
  static const Color parchmentGoldStroke = Color(
    0x33B88E28,
  ); // 20% opacity warm gold hairline stroke

  // ---------------------------------------------------------------------------
  // 4. Royal Emerald Sanctuary Foundations (Chic 4th Regal Serenity Theme)
  // ---------------------------------------------------------------------------
  static const Color emeraldSanctuaryCore = Color(
    0xFF060F0C,
  ); // Deep royal emerald night background
  static const Color emeraldSanctuaryCard = Color(
    0xFF0C1A14,
  ); // Regal dark forest card
  static const Color emeraldSanctuaryElevated = Color(
    0xFF13271F,
  ); // Elevated mint-tinted surface
  static const Color emeraldSanctuaryBorder = Color(
    0x2410B981,
  ); // Subtle luminous emerald border
  static const Color emeraldSanctuaryGlass = Color(
    0xCC0C1A14,
  ); // Translucent royal emerald glass
  static const Color emeraldSanctuaryMuted = Color(
    0xFF8DA39A,
  ); // Soft sage metallic captions

  // ---------------------------------------------------------------------------
  // Sacred Metallic Gold Accents (Dark Mode & Universal Accents)
  // ---------------------------------------------------------------------------
  static const Color champagneGold = Color(
    0xFFD4AF37,
  ); // Primary sacred accents & icons
  static const Color paleRadiance = Color(
    0xFFF3E5AB,
  ); // Soft luminescent highlights
  static const Color goldBorderStroke = Color(
    0x33D4AF37,
  ); // 20% opacity 1px hairline stroke
  static const Color goldGlowSoft = Color(
    0x1AD4AF37,
  ); // 10% opacity radiant aura

  // ---------------------------------------------------------------------------
  // Spiritual Emerald (Serenity, Healing, Streaks)
  // ---------------------------------------------------------------------------
  static const Color emeraldGlow = Color(
    0xFF10B981,
  ); // Serenity, bookmarks, progress
  static const Color deepSanctuary = Color(
    0xFF0B3B2C,
  ); // Background spiritual tint

  // ---------------------------------------------------------------------------
  // Dark Mode Typography & Universal Tokens
  // ---------------------------------------------------------------------------
  static const Color pureChalk = Color(
    0xFFF8FAFC,
  ); // High contrast Quranic text in dark
  static const Color mutedSilver = Color(
    0xFF94A3B8,
  ); // Metadata, translations, timestamps in dark
  static const Color softAmber = Color(0xFFFBBF24); // Warm bookmark indicators
  static const Color errorRed = Color(0xFFEF4444); // Error state indicator
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);

  // ---------------------------------------------------------------------------
  // Context-Aware Semantic Accessors (Convenience Helpers)
  // ---------------------------------------------------------------------------
  static Color backgroundOf(BuildContext context) => context.colors.background;
  static Color cardOf(BuildContext context) => context.colors.cardSurface;
  static Color textPrimaryOf(BuildContext context) =>
      context.colors.textPrimary;
  static Color textSecondaryOf(BuildContext context) =>
      context.colors.textSecondary;
  static Color borderOf(BuildContext context) => context.colors.borderHairline;
  static Color goldOf(BuildContext context) => context.colors.accentGold;
  static Color emeraldOf(BuildContext context) => context.colors.accentEmerald;
}
