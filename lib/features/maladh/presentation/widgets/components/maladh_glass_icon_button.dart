import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Reusable circular frosted glass action button with tactile haptics
/// and clean border styling without blurry drop shadows.
class MaladhGlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool showBadge;

  const MaladhGlassIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.lightImpact();
          onTap?.call();
        },
        customBorder: const CircleBorder(),
        splashColor: colors.accentGold.withValues(alpha: 0.1),
        highlightColor: Colors.transparent,
        child: Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: colors.cardSurface,
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.borderHairline,
              width: 1.r,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                color: colors.textPrimary,
                size: 18.r,
              ),
              if (showBadge)
                Positioned(
                  top: 9.r,
                  right: 9.r,
                  child: Container(
                    width: 7.r,
                    height: 7.r,
                    decoration: BoxDecoration(
                      color: colors.accentGold,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.cardSurface,
                        width: 1.2.r,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
