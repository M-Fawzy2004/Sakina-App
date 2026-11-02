import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_book_entity.dart';

class SunnahBookCard extends StatelessWidget {
  final SunnahBookEntity book;
  final VoidCallback onTap;

  const SunnahBookCard({
    super.key,
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSahih = book.key == 'bukhari' || book.key == 'muslim';

    return TactileGlassCard(
      onTap: () {
        HapticService.selectionClick();
        onTap();
      },
      padding: EdgeInsets.all(14.r),
      child: Row(
        children: [
          // Book Medallion Icon
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: isSahih
                  ? colors.accentGold.withValues(alpha: 0.12)
                  : colors.surfaceElevated,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isSahih
                    ? colors.accentGold.withValues(alpha: 0.35)
                    : colors.borderHairline,
                width: 1.r,
              ),
            ),
            child: Center(
              child: Icon(
                isSahih ? FlutterIslamicIcons.quran2 : FlutterIslamicIcons.prayingPerson,
                color: isSahih ? colors.accentGold : colors.accentEmerald,
                size: 22.r,
              ),
            ),
          ),

          SizedBox(width: 14.w),

          // Title & Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        book.titleAr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleMediumOf(context).copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    if (isSahih) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: colors.accentGold.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: colors.accentGold.withValues(alpha: 0.35),
                            width: 0.8.r,
                          ),
                        ),
                        child: Text(
                          'أصح الكتب',
                          style: AppTextStyles.captionOf(context).copyWith(
                            color: colors.accentGold,
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  book.authorAr.isNotEmpty ? book.authorAr : 'أحد أئمة الحديث النبوي',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.captionOf(context).copyWith(
                    color: colors.textSecondary,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    _MiniBadge(
                      text: '${book.hadithsCount} حديثاً',
                      color: colors.accentGold,
                    ),
                    SizedBox(width: 6.w),
                    _MiniBadge(
                      text: '${book.chaptersCount} كتاباً',
                      color: colors.accentEmerald,
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          Icon(
            Iconsax.arrow_left_2,
            size: 16.r,
            color: colors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _MiniBadge({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.5.h),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: colors.borderHairline,
          width: 0.8.r,
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.captionOf(context).copyWith(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

