import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/maladh/domain/entities/daily_hadith_item.dart';
import 'package:sakina_app/features/maladh/domain/services/daily_hadith_service.dart';
import 'package:sakina_app/features/maladh/presentation/widgets/components/daily_hadith_detail_bottom_sheet.dart';

class MaladhDailyHadithCard extends StatelessWidget {
  final DailyHadithItem? customHadith;

  const MaladhDailyHadithCard({
    super.key,
    this.customHadith,
  });

  void _openFullHadith(BuildContext context, DailyHadithItem hadith) {
    HapticService.selectionClick();
    DailyHadithDetailBottomSheet.show(context, hadith);
  }

  void _copyHadith(BuildContext context, DailyHadithItem hadith) {
    HapticService.selectionClick();
    final text = '«${hadith.arabic}»\n[${hadith.bookTitleAr} - ${hadith.narratorAr}]';
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'تم نسخ حديث اليوم إلى الحافظة',
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: context.colors.cardSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: context.colors.accentGold, width: 1.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hadith = customHadith ?? DailyHadithService.getTodayHadith();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: InkWell(
        onTap: () => _openFullHadith(context, hadith),
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: colors.cardSurface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: colors.borderHairline.withValues(alpha: 0.6),
              width: 0.8.r,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Top Ribbon: Title & Source Pill
              _DailyHadithHeader(
                bookTitleAr: hadith.bookTitleAr,
                topic: hadith.topic,
              ),

              SizedBox(height: 10.h),

              // 2. Prophetic Hadith Text (Compact: max 3 lines)
              Text(
                '«${hadith.arabic}»',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                style: AppTextStyles.quranAyahOf(context).copyWith(
                  fontSize: 14.5.sp,
                  height: 1.85,
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 10.h),

              // 3. Bottom Row: Narrator & Actions
              _DailyHadithFooter(
                narratorAr: hadith.narratorAr,
                onCopy: () => _copyHadith(context, hadith),
                onReadMore: () => _openFullHadith(context, hadith),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyHadithHeader extends StatelessWidget {
  final String bookTitleAr;
  final String? topic;

  const _DailyHadithHeader({
    required this.bookTitleAr,
    this.topic,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(
                FlutterIslamicIcons.quran2,
                size: 16.r,
                color: colors.accentGold,
              ),
              SizedBox(width: 6.w),
              Text(
                'حَدِيثُ اليَوْم',
                style: AppTextStyles.titleMediumOf(context).copyWith(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.accentGold,
                ),
              ),
              if (topic != null) ...[
                SizedBox(width: 8.w),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: colors.accentEmerald.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      topic!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.captionOf(context).copyWith(
                        color: colors.accentEmerald,
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: colors.surfaceElevated,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: colors.borderHairline.withValues(alpha: 0.7),
              width: 0.8.r,
            ),
          ),
          child: Text(
            bookTitleAr,
            style: AppTextStyles.captionOf(context).copyWith(
              color: colors.textSecondary,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _DailyHadithFooter extends StatelessWidget {
  final String narratorAr;
  final VoidCallback onCopy;
  final VoidCallback onReadMore;

  const _DailyHadithFooter({
    required this.narratorAr,
    required this.onCopy,
    required this.onReadMore,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: Text(
            narratorAr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.captionOf(context).copyWith(
              color: colors.textSecondary,
              fontSize: 10.5.sp,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Iconsax.copy,
            size: 16.r,
            color: colors.textSecondary,
          ),
          onPressed: onCopy,
          tooltip: 'نسخ الحديث',
          constraints: const BoxConstraints(),
          padding: EdgeInsets.all(4.r),
        ),
        SizedBox(width: 8.w),
        InkWell(
          onTap: onReadMore,
          borderRadius: BorderRadius.circular(6.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'قراءة كاملة',
                  style: AppTextStyles.captionOf(context).copyWith(
                    color: colors.accentGold,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 2.w),
                Icon(
                  Iconsax.arrow_left_2,
                  size: 12.r,
                  color: colors.accentGold,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
