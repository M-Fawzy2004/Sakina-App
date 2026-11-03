import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/maladh/domain/entities/daily_hadith_item.dart';

/// Modal bottom sheet presenting the complete daily hadith in full fidelity,
/// eliminating the need to navigate to external screens.
class DailyHadithDetailBottomSheet extends StatelessWidget {
  final DailyHadithItem hadith;

  const DailyHadithDetailBottomSheet({
    super.key,
    required this.hadith,
  });

  static Future<void> show(BuildContext context, DailyHadithItem hadith) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (_) => DailyHadithDetailBottomSheet(hadith: hadith),
    );
  }

  void _copyHadith(BuildContext context) {
    HapticService.selectionClick();
    final text = '«${hadith.arabic}»\n[${hadith.bookTitleAr} - ${hadith.narratorAr}]';
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'تم نسخ الحديث الشريف إلى الحافظة',
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
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.85.sh),
        padding: EdgeInsets.only(
          left: 18.w,
          right: 18.w,
          top: 14.h,
          bottom: bottomInset > 0 ? bottomInset + 12.h : 20.h,
        ),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          border: Border.all(
            color: colors.borderHairline.withValues(alpha: 0.7),
            width: 1.r,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.borderHairline,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        FlutterIslamicIcons.quran2,
                        size: 18.r,
                        color: colors.accentGold,
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          'حَدِيثُ اليَوْمِ الشَّرِيف',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleMediumOf(context).copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Iconsax.close_circle,
                    size: 20.r,
                    color: colors.textSecondary,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Text(
                  '«${hadith.arabic}»',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.quranAyahOf(context).copyWith(
                    fontSize: 20.sp,
                    height: 2.15,
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              '${hadith.bookTitleAr} • ${hadith.narratorAr}',
              textAlign: TextAlign.center,
              style: AppTextStyles.captionOf(context).copyWith(
                color: colors.accentGold,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 14.h),
            OutlinedButton.icon(
              onPressed: () => _copyHadith(context),
              icon: Icon(
                Iconsax.copy,
                size: 16.r,
                color: colors.accentGold,
              ),
              label: Text(
                'نسخ الحديث الشريف',
                style: AppTextStyles.captionOf(context).copyWith(
                  color: colors.accentGold,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: colors.accentGold.withValues(alpha: 0.5),
                  width: 1.r,
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
