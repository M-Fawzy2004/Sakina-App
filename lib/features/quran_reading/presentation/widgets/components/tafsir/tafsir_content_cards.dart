import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';

/// Dedicated card presenting the authentic exegesis with high-legibility typography.
class TafsirBodyCard extends StatelessWidget {
  final String tafsirType;
  final String tafsirText;

  const TafsirBodyCard({
    super.key,
    required this.tafsirType,
    required this.tafsirText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.borderHairline, width: 1.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tafsirType,
                style: AppTextStyles.caption.copyWith(
                  color: colors.accentGold,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5.sp,
                ),
              ),
              Icon(
                Iconsax.book_1,
                color: colors.accentGold,
                size: 17.r,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            tafsirText,
            style: GoogleFonts.cairo(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
              height: 1.85,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Callout card displaying spiritual contemplation (التدبر الإيماني).
class SpiritualReflectionCard extends StatelessWidget {
  final String reflectionText;

  const SpiritualReflectionCard({
    super.key,
    required this.reflectionText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colors.accentEmerald.withValues(alpha: 0.45),
          width: 0.9.r,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Iconsax.lamp_charge,
            color: colors.accentEmerald,
            size: 18.r,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'التَّدَبُّرُ الإِيمَانِيُّ',
                  style: AppTextStyles.caption.copyWith(
                    color: colors.accentEmerald,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  reflectionText,
                  style: GoogleFonts.cairo(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                    height: 1.6,
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

/// Action bar at the bottom containing Copy and Juz/Page label.
class TafsirBottomBar extends StatelessWidget {
  final AyahEntity ayah;
  final VoidCallback onCopy;

  const TafsirBottomBar({
    super.key,
    required this.ayah,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colors.borderHairline.withValues(alpha: 0.5),
            width: 0.8.r,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: onCopy,
            icon: Icon(
              Iconsax.copy,
              color: colors.accentEmerald,
              size: 16.r,
            ),
            label: Text(
              'نَسْخ',
              style: AppTextStyles.caption.copyWith(
                color: colors.accentEmerald,
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
          ),
          Text(
            'جُزْءُ ${ayah.juz} • ص ${ayah.page}',
            style: AppTextStyles.caption.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}

