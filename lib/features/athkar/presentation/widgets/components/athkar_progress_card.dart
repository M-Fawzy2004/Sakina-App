import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';

/// Progress summary card for active Athkar category.
class AthkarProgressCard extends StatelessWidget {
  final String categoryName;
  final String description;
  final int totalCount;
  final int completedCount;
  final double progress;

  const AthkarProgressCard({
    super.key,
    required this.categoryName,
    required this.description,
    required this.totalCount,
    required this.completedCount,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final percent = (progress * 100).round();
    final isFullyCompleted = completedCount >= totalCount && totalCount > 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TactileGlassCard(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Right Side: Category Name & Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryName,
                        style: GoogleFonts.cairo(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: colors.accentGold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w500,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 8.w),

                // Left Side: Status Badge
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isFullyCompleted
                        ? colors.accentEmerald.withValues(alpha: 0.15)
                        : colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isFullyCompleted
                          ? colors.accentEmerald
                          : colors.borderHairline,
                      width: 1.r,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isFullyCompleted ? Iconsax.tick_circle : Iconsax.timer_1,
                        size: 13.r,
                        color: isFullyCompleted
                            ? colors.accentEmerald
                            : colors.accentGold,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '$completedCount من $totalCount',
                        style: GoogleFonts.cairo(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: isFullyCompleted
                              ? colors.accentEmerald
                              : colors.accentGold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5.h,
                backgroundColor: colors.surfaceElevated,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isFullyCompleted ? colors.accentEmerald : colors.accentGold,
                ),
              ),
            ),

            SizedBox(height: 6.h),

            // Percentage Label
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isFullyCompleted
                      ? 'مبارك! أتممت هذا الورد المبارك'
                      : 'واصل الذكر واكسب الأجر',
                  style: GoogleFonts.cairo(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w500,
                    color: isFullyCompleted
                        ? colors.accentEmerald
                        : colors.textSecondary,
                  ),
                ),
                Text(
                  '$percent%',
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

