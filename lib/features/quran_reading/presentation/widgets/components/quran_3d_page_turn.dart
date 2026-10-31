import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sakina_app/core/theme/app_colors.dart';

/// 3D Realistic Manuscript & Notebook Page-Flip Physics Container.
/// Transforms 2D page transitions into a physical 3D paper-curling motion
/// with perspective rotation along the book spine and dynamic fold shading.
class Quran3dPageTurn extends StatelessWidget {
  final int pageIndex;
  final double currentPageValue;
  final Widget child;

  const Quran3dPageTurn({
    super.key,
    required this.pageIndex,
    required this.currentPageValue,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final diff = pageIndex - currentPageValue;

    // Fast path: fully off-screen pages or resting page without transformation
    if (diff.abs() >= 1.0) {
      if (diff > 0) return const SizedBox.shrink();
    }

    // Perspective 3D rotation matrix
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final double angle = (diff * (math.pi / 3.2)).clamp(-math.pi / 2.2, math.pi / 2.2);

    final transformMatrix = Matrix4.identity()
      ..setEntry(3, 2, 0.0014) // Perspective depth
      ..rotateY(isRtl ? -angle : angle);

    // Spine anchor alignment
    final alignment = isRtl
        ? (diff < 0 ? Alignment.centerRight : Alignment.centerLeft)
        : (diff < 0 ? Alignment.centerLeft : Alignment.centerRight);

    // Fold Shadow calculation (dynamic spine shading while curling)
    final double shadowOpacity = (diff.abs() * 0.45).clamp(0.0, 0.45);

    return Transform(
      transform: transformMatrix,
      alignment: alignment,
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,

          // Dynamic 3D spine fold shadow overlay
          if (shadowOpacity > 0.01)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: isRtl ? Alignment.centerRight : Alignment.centerLeft,
                      end: isRtl ? Alignment.centerLeft : Alignment.centerRight,
                      colors: [
                        AppColors.obsidianCore.withValues(alpha: shadowOpacity),
                        Colors.transparent,
                        AppColors.obsidianCore.withValues(alpha: shadowOpacity * 0.6),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

