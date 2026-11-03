import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';

/// Header containing the sacred order medallion and repetition counter badge.
class AthkarCardHeader extends StatelessWidget {
  final int index;
  final int targetCount;
  final bool isCompleted;

  const AthkarCardHeader({
    super.key,
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
                style: GoogleFonts.almarai(
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
class AthkarCardBodyText extends StatelessWidget {
  final String content;

  const AthkarCardBodyText({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Text(
      content,
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
      style: GoogleFonts.amiri(
        fontSize: 21.sp,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
        height: 2.05,
      ),
    );
  }
}

/// Soothing Virtue and Reward card.
class AthkarVirtueBox extends StatelessWidget {
  final String description;

  const AthkarVirtueBox({super.key, required this.description});

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
class AthkarReferencePill extends StatelessWidget {
  final String reference;

  const AthkarReferencePill({super.key, required this.reference});

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

