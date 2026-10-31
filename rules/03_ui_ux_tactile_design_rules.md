# UI/UX, TACTILE LUXURY & SENSORY DESIGN RULES
**Visual Paradigm:** Tactile Dark Luxury, Spiritual Zen, OLED Immersion  
**Frame Rate Standard:** Strictly 60fps - 120fps (ProMotion Target)  
**Sensory Feedback:** Haptic Actuation on Every Primary Touch

---

## 1. THE DUAL LUXURY COLOR SYSTEM (`AppColors` & `AppColorsScheme`)
Every color must resolve from `context.colors` (or `AppColorsScheme`), supporting both:
1. **OLED Dark Luxury Theme** (`obsidianCore` foundation)
2. **Calming Sacred Parchment Light Theme** (`parchmentCore` foundation `#F6EDE2` - restful Holy Quran manuscript aesthetic)

```dart
import 'package:flutter/material.dart';

abstract final class AppColors {
  // Dark Foundations (OLED Pure & Slate)
  static const Color obsidianCore     = Color(0xFF080A0C); // OLED primary background
  static const Color carbonSlate       = Color(0xFF0F1316); // Elevated card foundation
  static const Color frostedGlass      = Color(0x66151A21); // 40% translucent surface
  static const Color surfaceElevated   = Color(0xFF1E242B); // Secondary surface

  // Light Foundations (Calming Sacred Parchment - Zero Eye-Strain)
  static const Color parchmentCore     = Color(0xFFF6EDE2); // Soothing primary paper background
  static const Color parchmentCard     = Color(0xFFEDE6D7); // Elevated warm cream card foundation
  static const Color parchmentElevated = Color(0xFFE2DACB); // Secondary elevated cream surface
  static const Color parchmentBorder   = Color(0xFFD7D1C3); // Soft warm hairline divider stroke
  static const Color inkDeep           = Color(0xFF241E19); // High-contrast restful deep umber text
  static const Color inkMuted          = Color(0xFF766C62); // Muted slate umber for captions
  static const Color warmGold          = Color(0xFFB88E28); // Calibrated antique sacred gold on light
  static const Color forestEmerald     = Color(0xFF1B6A50); // Calibrated deep forest emerald on light

  // Sacred Metallic Gold Accents (Universal)
  static const Color champagneGold     = Color(0xFFD4AF37); // Primary sacred accents & icons
  static const Color paleRadiance       = Color(0xFFF3E5AB); // Soft luminescent highlights
  static const Color goldBorderStroke   = Color(0x33D4AF37); // 20% opacity 1px hairline stroke

  // Spiritual Emerald Accents (Universal)
  static const Color emeraldGlow       = Color(0xFF10B981); // Serenity, bookmarks, progress
  static const Color deepSanctuary     = Color(0xFF0B3B2C); // Background spiritual tint

  // Dark Typography
  static const Color pureChalk         = Color(0xFFF8FAFC); // High contrast Quranic text
  static const Color mutedSilver       = Color(0xFF94A3B8); // Metadata, translations, timestamps
  static const Color softAmber         = Color(0xFFFBBF24); // Warm bookmark indicators
  static const Color errorRed          = Color(0xFFEF4444); // Error state indicator

  // Context-Aware Dynamic Resolution:
  // Prefer `context.colors.background`, `context.colors.cardSurface`, `context.colors.textPrimary`
}
```

---

## 2. GLASSMORPHISM & TACTILE DEPTH CONTAINER
Do not use generic `Card` or plain rectangular containers. Every card is an elevated frosted glass slab featuring an inner specular backdrop filter, a 1px hairline gold border, and calibrated shadow depth:

```dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

class TactileGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const TactileGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(20.r);

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveRadius,
          child: Container(
            padding: padding ?? EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.frostedGlass,
              borderRadius: effectiveRadius,
              border: Border.all(
                color: AppColors.goldBorderStroke,
                width: 1.r,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

---

## 3. PHYSICAL 3D EMBROIDERED BOOKMARK (RIBBON PHYSICS)
The digital Quran reading screen must feature an interactive ribbon bookmark:
- Anchored at the top-right safe area margin.
- **Visual Texture:** Rich fabric gradient (`AppColors.deepSanctuary` base with subtle stitched golden hairline edges).
- **Physical Motion:** Pulling down triggers an elastic physics spring simulation (`SpringSimulation` or `InteractiveViewer`) dropping a soft dynamic shadow on the underlying text.
- **Haptic Confirmation:** When the bookmark locks in place or is toggled, invoke `HapticFeedback.heavyImpact()`.

---

## 4. TYPOGRAPHY & SACRED RENDERING RULES
- **Quranic Verses:** Must use standard, approved Uthmanic fonts (`KFGQPC Uthmanic Script HAFS`).
  - Text must render with adequate line height (`height: 2.1 - 2.4`) to prevent diacritical collision (Tashkeel overlapping).
  - Explicit letter spacing: `letterSpacing: 0.5`.
- **Headings & Titles:** Authentic Arabic Calligraphy (`Amiri` or `Thuluth`).
- **Body & Subtitles:** Sleek, modern Arabic typography (`Cairo` or `IBM Plex Sans Arabic`).

---

## 5. HAPTIC FEEDBACK SPECIFICATION
Every user interaction must convey tangible physical resistance and sensory feedback:
- Tab selection / Bottom nav switch: `HapticFeedback.selectionClick()`
- Toggle switch / Audio Play / Pause: `HapticFeedback.lightImpact()`
- Bookmark set / Reset progress: `HapticFeedback.mediumImpact()`
- "Emergency / Inaba Refuge Button": `HapticFeedback.heavyImpact()` followed by rhythmic breathing pulsations.

