import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_item_entity.dart';

/// Inspiring Tactile Dark Luxury Card for a sacred Thikr item.
/// Features:
/// 1. Ornamental Islamic Medallion Header with dynamic repetition badge.
/// 2. Clear, authentic Tashkeel typography with safe line-height.
/// 3. Soothing Virtue & Reward ("فَضْلُ الذِّكْرِ") quote section.
/// 4. Interactive Concentric Tasbih Counter Medallion with haptic micro-pulses.
/// 5. Smooth Emerald Sanctuary completion transformation.
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
          'تَمَّ نَسْخُ الذِّكْرِ المُبَارَكِ لِلحَافِظَةِ',
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.pureChalk,
          ),
        ),
        backgroundColor: AppColors.carbonSlate,
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isCompleted
                ? colors.accentEmerald.withValues(alpha: 0.35)
                : colors.borderHairline,
            width: isCompleted ? 1.4.r : 1.r,
          ),
        ),
        padding: EdgeInsets.all(18.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Ornamental Header Bar
            _AthkarCardHeader(
              index: itemIndex,
              targetCount: item.count,
              isCompleted: isCompleted,
            ),

            SizedBox(height: 14.h),

            // 2. Venerable Arabic Body Text
            _AthkarCardBodyText(content: item.content),

            // 3. Virtue / Reward Container (فضيلة الذكر وثوابه)
            if (item.description.isNotEmpty) ...[
              SizedBox(height: 14.h),
              _AthkarVirtueBox(description: item.description),
            ],

            // 4. Hadith Reference Pill
            if (item.reference.isNotEmpty) ...[
              SizedBox(height: 8.h),
              _AthkarReferencePill(reference: item.reference),
            ],

            SizedBox(height: 16.h),

            // 5. Interactive Concentric Tasbih Counter Row
            _AthkarInteractiveTasbihRow(
              isCompleted: isCompleted,
              remaining: remaining,
              targetCount: item.count,
              progress: progress,
              currentRepetitions: currentRepetitions,
              onTapCount: onTapCount,
              onReset: onReset,
              onCopy: () => _copyThikr(context),
            ),
          ],
        ),
      ),
    );
  }
}

/// Header containing the sacred order medallion and repetition counter badge.
class _AthkarCardHeader extends StatelessWidget {
  final int index;
  final int targetCount;
  final bool isCompleted;

  const _AthkarCardHeader({
    required this.index,
    required this.targetCount,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Right Side: Order Medallion
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28.r,
              height: 28.r,
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted
                      ? colors.accentEmerald
                      : colors.accentGold.withValues(alpha: 0.6),
                  width: 1.r,
                ),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: isCompleted ? colors.accentEmerald : colors.accentGold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'الذِّكْرُ المُبَارَكُ',
              style: GoogleFonts.cairo(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: isCompleted ? colors.accentEmerald : colors.accentGold,
              ),
            ),
          ],
        ),

        // Left Side: Repetition Pill
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isCompleted
                ? colors.accentEmerald.withValues(alpha: 0.15)
                : colors.surfaceElevated,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isCompleted
                  ? colors.accentEmerald.withValues(alpha: 0.5)
                  : colors.borderHairline,
              width: 1.r,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCompleted ? Iconsax.tick_circle : Iconsax.repeat,
                size: 13.r,
                color: isCompleted ? colors.accentEmerald : colors.accentGold,
              ),
              SizedBox(width: 5.w),
              Text(
                '$targetCount ${targetCount == 1 ? "مَرَّة" : "مَرَّاتٍ"}',
                style: GoogleFonts.cairo(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: isCompleted ? colors.accentEmerald : colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The sacred Thikr body text rendered with optimal Quranic readability.
class _AthkarCardBodyText extends StatelessWidget {
  final String content;

  const _AthkarCardBodyText({required this.content});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Text(
      content,
      textAlign: TextAlign.start,
      textDirection: TextDirection.rtl,
      style: GoogleFonts.cairo(
        fontSize: 17.sp,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
        height: 1.9,
        letterSpacing: 0.1,
      ),
    );
  }
}

/// Soothing Virtue and Reward card.
class _AthkarVirtueBox extends StatelessWidget {
  final String description;

  const _AthkarVirtueBox({required this.description});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colors.accentGold.withValues(alpha: 0.2),
          width: 1.r,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Iconsax.lamp_charge,
            size: 16.r,
            color: colors.accentGold,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'فَضْلُ الذِّكْرِ وَأَجْرُهُ:',
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: colors.accentGold,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  description,
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Subtle source reference pill.
class _AthkarReferencePill extends StatelessWidget {
  final String reference;

  const _AthkarReferencePill({required this.reference});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Iconsax.book_1,
          size: 12.r,
          color: colors.textSecondary,
        ),
        SizedBox(width: 5.w),
        Text(
          reference,
          style: GoogleFonts.cairo(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Hero Concentric Tasbih Counter Action Row.
class _AthkarInteractiveTasbihRow extends StatelessWidget {
  final bool isCompleted;
  final int remaining;
  final int targetCount;
  final double progress;
  final int currentRepetitions;
  final VoidCallback onTapCount;
  final VoidCallback onReset;
  final VoidCallback onCopy;

  const _AthkarInteractiveTasbihRow({
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
