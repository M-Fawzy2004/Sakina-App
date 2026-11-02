import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';

/// Hero Concentric Tasbih Counter Action Row.
class AthkarInteractiveTasbihRow extends StatelessWidget {
  final bool isCompleted;
  final int remaining;
  final int targetCount;
  final double progress;
  final int currentRepetitions;
  final VoidCallback onTapCount;
  final VoidCallback onReset;
  final VoidCallback onCopy;

  const AthkarInteractiveTasbihRow({
    super.key,
    required this.isCompleted,
    required this.remaining,
    required this.targetCount,
    required this.progress,
    required this.currentRepetitions,
    required this.onTapCount,
    required this.onReset,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Secondary Tools (Copy & Reset)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Iconsax.copy,
                size: 18.r,
                color: colors.textSecondary,
              ),
              onPressed: onCopy,
              tooltip: 'نسخ الذكر',
            ),
            if (currentRepetitions > 0)
              IconButton(
                icon: Icon(
                  Iconsax.rotate_left,
                  size: 18.r,
                  color: colors.textSecondary,
                ),
                onPressed: onReset,
                tooltip: 'إعادة التكرار',
              ),
          ],
        ),

        // Main Tactile Tasbih Medallion Button
        GestureDetector(
          onTap: isCompleted ? null : onTapCount,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: isCompleted ? 18.w : 22.w,
              vertical: 9.h,
            ),
            decoration: BoxDecoration(
              color: isCompleted
                  ? colors.accentEmerald
                  : colors.accentGold,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isCompleted) ...[
                  Icon(
                    Iconsax.tick_circle,
                    size: 17.r,
                    color: colors.isDark ? AppColors.obsidianCore : AppColors.white,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'تَمَّ بِحَمْدِ اللَّهِ',
                    style: GoogleFonts.cairo(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w800,
                      color: colors.isDark ? AppColors.obsidianCore : AppColors.white,
                    ),
                  ),
                ] else ...[
                  Text(
                    'المُتَبَقِّي: $remaining',
                    style: GoogleFonts.cairo(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: colors.isDark ? AppColors.obsidianCore : AppColors.white,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  SizedBox(
                    width: 15.r,
                    height: 15.r,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 2.6.r,
                      backgroundColor: (colors.isDark
                              ? AppColors.obsidianCore
                              : AppColors.white)
                          .withValues(alpha: 0.28),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colors.isDark ? AppColors.obsidianCore : AppColors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

