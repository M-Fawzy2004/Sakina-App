import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/constants/app_assets.dart';

/// Foreground high-resolution Calligraphy / Emblem layer positioned on top of the background.
class SplashForegroundLogo extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;

  const SplashForegroundLogo({
    super.key,
    required this.fadeAnimation,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Center(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: SizedBox(
              width: 300.w,
              child: Image.asset(
                AppAssets.splashImage,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

