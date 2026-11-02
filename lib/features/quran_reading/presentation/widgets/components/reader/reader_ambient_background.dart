import 'package:flutter/material.dart';
import 'package:sakina_app/core/constants/app_assets.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_reader_preferences.dart';

/// Translucent spiritual holy mosque background with dynamic theme gradient veil.
class ReaderAmbientBackground extends StatelessWidget {
  final QuranReaderTheme theme;

  const ReaderAmbientBackground({
    super.key,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Spiritual Holy Mosque Wallpaper
        Positioned.fill(
          child: Image.asset(
            AppAssets.quranBackground,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),

        // 2. Translucent Ambient Theme Gradient Veil
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.backgroundColor.withValues(alpha: 0.40),
                  theme.backgroundColor.withValues(alpha: 0.78),
                  theme.backgroundColor.withValues(alpha: 0.96),
                ],
                stops: const [0.0, 0.35, 0.85],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

