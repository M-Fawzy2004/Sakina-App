import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Reusable circular frosted glass action button with tactile haptics
/// and clean border styling without blurry drop shadows.
class MaladhGlassIconButton extends StatelessWidget {
  final dynamic icon;
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.lightImpact();
          onTap?.call();
        },
        customBorder: const CircleBorder(),
        splashColor: AppColors.goldGlowSoft,
        highlightColor: Colors.transparent,
        child: Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: AppColors.frostedGlass,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.goldBorderStroke,
              width: 1.r,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (icon is List<List<dynamic>>)
                HugeIcon(
                  icon: icon,
                  color: AppColors.pureChalk,
                  size: 18.r,
                )
              else if (icon is IconData)
                Icon(
                  icon as IconData,
                  color: AppColors.pureChalk,
                  size: 18.r,
                ),
              if (showBadge)
                Positioned(
                  top: 8.r,
                  right: 8.r,
                  child: Container(
                    width: 7.r,
                    height: 7.r,
                    decoration: const BoxDecoration(
                      color: AppColors.emeraldGlow,
                      shape: BoxShape.circle,
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
