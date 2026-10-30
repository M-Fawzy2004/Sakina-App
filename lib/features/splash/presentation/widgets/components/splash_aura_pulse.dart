import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

class SplashAuraPulse extends StatelessWidget {
  final Animation<double> pulseAnimation;

  const SplashAuraPulse({
    super.key,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Center(
        child: FadeTransition(
          opacity: pulseAnimation,
          child: Container(
            width: 280.r,
            height: 280.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.goldGlowSoft,
                  Colors.transparent,
                ],
                stops: [0.0, 0.85],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

