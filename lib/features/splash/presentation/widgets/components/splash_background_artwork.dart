import 'package:flutter/material.dart';
import 'package:sakina_app/core/constants/app_assets.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

/// Full-screen ambient luxury background image layer.
class SplashBackgroundArtwork extends StatelessWidget {
  final Animation<double> fadeAnimation;

  const SplashBackgroundArtwork({
    super.key,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          color: AppColors.obsidianCore,
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            AppAssets.splashBackground,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}
