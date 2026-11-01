import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_item_entity.dart';

/// Interactive Tactile Card for a single Thikr item.
class AthkarItemCard extends StatelessWidget {
  final AthkarItemEntity item;
  final int itemIndex;
  final int currentRepetitions;
  final VoidCallback onTapCount;
  final VoidCallback onReset;

  const AthkarItemCard({
    super.key,
    required this.item,
    required this.itemIndex,
    required this.currentRepetitions,
    required this.onTapCount,
    required this.onReset,
  });

  void _copyThikr(BuildContext context) {
    HapticService.selectionClick();
    Clipboard.setData(ClipboardData(text: item.content));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تَمَّ نَسْخُ الذِّكْرِ المُبَارَكِ',
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isCompleted = currentRepetitions >= item.count;
    final remaining = (item.count - currentRepetitions).clamp(0, item.count);
    final progress = (currentRepetitions / item.count).clamp(0.0, 1.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: TactileGlassCard(
        padding: EdgeInsets.all(18.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header Metadata Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Thikr Index Pill
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: colors.borderHairline,
                      width: 1.r,
                    ),
                  ),
                  child: Text(
                    'الذِّكْرُ #${itemIndex + 1}',
                    style: GoogleFonts.cairo(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.accentGold,
                    ),
                  ),
                ),

                // Repetitions Badge
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? colors.accentEmerald.withValues(alpha: 0.15)
                        : colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    'التَّكْرَارُ: ${item.count}',
                    style: GoogleFonts.cairo(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: isCompleted
                          ? colors.accentEmerald
                          : colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 14.h),

            // 2. Thikr Sacred Body Text
            Text(
              item.content,
              textAlign: TextAlign.start,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.cairo(
                fontSize: 16.5.sp,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
                height: 1.85,
              ),
            ),

            // 3. Virtue / Description Box (إذا وجد فضل)
            if (item.description.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: colors.borderHairline,
                    width: 1.r,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Iconsax.quote_down,
                      size: 14.r,
                      color: colors.accentGold,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        item.description,
                        style: GoogleFonts.cairo(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w500,
                          color: colors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // 4. Reference (إذا وجد مصدر)
            if (item.reference.isNotEmpty) ...[
              SizedBox(height: 6.h),
              Text(
                item.reference,
                style: GoogleFonts.cairo(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.textSecondary,
                ),
              ),
            ],

            SizedBox(height: 16.h),

            // 5. Tactile Interactive Tasbih Counter Action Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Secondary Tools: Reset & Copy
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Copy Button
                    IconButton(
                      icon: Icon(
                        Iconsax.copy,
                        size: 18.r,
                        color: colors.textSecondary,
                      ),
                      onPressed: () => _copyThikr(context),
                      tooltip: 'نسخ الذكر',
                    ),
                    // Reset Button
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

                // Main Tactile Counter Button
                GestureDetector(
                  onTap: isCompleted ? null : onTapCount,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompleted ? 16.w : 22.w,
                      vertical: 10.h,
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
                            size: 16.r,
                            color: colors.isDark
                                ? AppColors.obsidianCore
                                : AppColors.white,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'اكْتَمَلَ الذِّكْرُ',
                            style: GoogleFonts.cairo(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              color: colors.isDark
                                  ? AppColors.obsidianCore
                                  : AppColors.white,
                            ),
                          ),
                        ] else ...[
                          Text(
                            'المُتَبَقِّي: $remaining',
                            style: GoogleFonts.cairo(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              color: colors.isDark
                                  ? AppColors.obsidianCore
                                  : AppColors.white,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          SizedBox(
                            width: 14.r,
                            height: 14.r,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 2.5.r,
                              backgroundColor: (colors.isDark
                                      ? AppColors.obsidianCore
                                      : AppColors.white)
                                  .withValues(alpha: 0.25),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colors.isDark
                                    ? AppColors.obsidianCore
                                    : AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
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

