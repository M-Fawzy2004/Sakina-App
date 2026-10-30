import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

/// Floating, levitating 3D artwork component with a serene golden aura pulse.
class OnboardingFloatingArtwork extends StatefulWidget {
  final String imageAsset;

  const OnboardingFloatingArtwork({
    super.key,
    required this.imageAsset,
  });

  @override
  State<OnboardingFloatingArtwork> createState() => _OnboardingFloatingArtworkState();
}

class _OnboardingFloatingArtworkState extends State<OnboardingFloatingArtwork>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Slow, serene spiritual breathing & levitation loop (3200ms)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -7.h, end: 7.h).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOut,
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.20, end: 0.65).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: SizedBox(
            height: 310.h,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. Soft Ambient Golden Glow Halo behind the transparent PNG
                FadeTransition(
                  opacity: _glowAnimation,
                  child: Container(
                    width: 220.r,
                    height: 220.r,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.goldGlowSoft,
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.8],
                      ),
                    ),
                  ),
                ),

                // 2. High-Resolution Transparent PNG scaled to optimal luxury dimensions
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Image.asset(
                    widget.imageAsset,
                    height: 290.h,
                    width: 290.w,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

