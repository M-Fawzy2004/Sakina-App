import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/hadith_entity.dart';

class HadithPageCard extends StatelessWidget {
  final HadithEntity hadith;
  final String bookTitle;
  final String? chapterTitle;
  final int currentIndex;
  final int totalCount;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const HadithPageCard({
    super.key,
    required this.hadith,
    required this.bookTitle,
    this.chapterTitle,
    required this.currentIndex,
    required this.totalCount,
    this.onPrevious,
    this.onNext,
  });

  void _copyHadith(BuildContext context) {
    HapticService.selectionClick();
    final text = '[$bookTitle - حديث رقم ${hadith.idInBook}]\n\n${hadith.arabic}';
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: colors.borderHairline.withValues(alpha: 0.8),
            width: 1.r,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Header: Hadith Number & Chapter Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: colors.accentGold.withValues(alpha: 0.5),
                      width: 1.r,
                    ),
                  ),
                  child: Text(
                    'حديث #${hadith.idInBook}',
                    style: AppTextStyles.captionOf(context).copyWith(
                      color: colors.accentGold,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (chapterTitle != null && chapterTitle!.isNotEmpty)
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: colors.borderHairline.withValues(alpha: 0.7),
                          width: 0.8.r,
                        ),
                      ),
                      child: Text(
                        chapterTitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.captionOf(context).copyWith(
                          color: colors.accentEmerald,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 16.h),

            // Main Arabic Hadith Text
            Expanded(
              child: Scrollbar(
                thumbVisibility: false,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                  child: Text(
                    hadith.arabic,
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
            ),

            SizedBox(height: 12.h),

            // Bottom Navigation & Actions Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous button
                IconButton(
                  onPressed: onPrevious,
                  icon: Icon(
                    Iconsax.arrow_right_3,
                    size: 20.r,
                    color: onPrevious != null
                        ? colors.textPrimary
                        : colors.textSecondary.withValues(alpha: 0.25),
                  ),
                  tooltip: 'الحديث السابق',
                ),

                // Counter Badge (Directionality LTR ensures "1 / 7277" order)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: colors.borderHairline.withValues(alpha: 0.7),
                      width: 0.8.r,
                    ),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      '${currentIndex + 1} / $totalCount',
                      style: AppTextStyles.captionOf(context).copyWith(
                        color: colors.textSecondary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Next button
                IconButton(
                  onPressed: onNext,
                  icon: Icon(
                    Iconsax.arrow_left_2,
                    size: 20.r,
                    color: onNext != null
                        ? colors.textPrimary
                        : colors.textSecondary.withValues(alpha: 0.25),
                  ),
                  tooltip: 'الحديث التالي',
                ),

                // Copy button
                IconButton(
                  icon: Icon(
                    Iconsax.copy,
                    size: 19.r,
                    color: colors.accentGold,
                  ),
                  onPressed: () => _copyHadith(context),
                  tooltip: 'نسخ الحديث',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
