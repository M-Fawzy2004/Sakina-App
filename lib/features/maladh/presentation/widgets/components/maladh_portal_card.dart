import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';

/// Single portal card inside "بَوَّابَاتُ السَّكِينَةِ" grid.
/// Clean, elevated OLED dark slab without drop shadows.
class MaladhPortalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badgeText;
  final Widget iconWidget;
  final bool isEmerald;
  final VoidCallback? onTap;

  const MaladhPortalCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.iconWidget,
    this.isEmerald = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TactileGlassCard(
      onTap: () {
        HapticService.selectionClick();
        onTap?.call();
      },
      padding: EdgeInsets.all(14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Top Row: Icon Container (RTL Start) + Status Badge (RTL End)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon Container
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: isEmerald
                      ? const Color(0x2210B981)
                      : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isEmerald
                        ? const Color(0x5510B981)
                        : AppColors.goldBorderStroke,
                    width: 1.r,
                  ),
                ),
                child: Center(child: iconWidget),
              ),

              // Status Badge Pill
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isEmerald
                      ? const Color(0x2210B981)
                      : AppColors.carbonSlate,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isEmerald
                        ? const Color(0x5510B981)
                        : AppColors.goldBorderStroke,
                    width: 1.r,
                  ),
                ),
                child: Text(
                  badgeText,
                  style: AppTextStyles.caption.copyWith(
                    color: isEmerald
                        ? AppColors.emeraldGlow
                        : AppColors.champagneGold,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // 2. Title & Subtitle Area
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.pureChalk,
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.mutedSilver,
                  fontSize: 10.5.sp,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

