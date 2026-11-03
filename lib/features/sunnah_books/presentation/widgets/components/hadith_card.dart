import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/hadith_entity.dart';

class HadithCard extends StatelessWidget {
  final HadithEntity hadith;
  final String bookTitle;
  final String? chapterTitle;

  const HadithCard({
    super.key,
    required this.hadith,
    required this.bookTitle,
    this.chapterTitle,
  });

  void _copyHadith(BuildContext context) {
    HapticService.selectionClick();
    final text = '[$bookTitle - حديث رقم ${hadith.idInBook}]\n\n${hadith.arabic}';
    Clipboard.setData(ClipboardData(text: text));

    AppTopSnackBar.show(
      context: context,
      message: 'تم نسخ الحديث الشريف إلى الحافظة',
      icon: Iconsax.copy,
      iconColor: context.colors.accentGold,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TactileGlassCard(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Header: Hadith Number Pill & Chapter Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: colors.accentGold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: colors.accentGold.withValues(alpha: 0.35),
                    width: 1.r,
                  ),
                ),
                child: Text(
                  'حديث #${hadith.idInBook}',
                  style: AppTextStyles.captionOf(context).copyWith(
                    color: colors.accentGold,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (chapterTitle != null && chapterTitle!.isNotEmpty)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      chapterTitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppTextStyles.captionOf(context).copyWith(
                        color: colors.textSecondary,
                        fontSize: 10.5.sp,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 14.h),

          // Main Arabic Text with Matn & Sanad
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: colors.surfaceElevated.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: colors.borderHairline,
                width: 0.8.r,
              ),
            ),
            child: Text(
              hadith.arabic,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTextStyles.quranAyahOf(context).copyWith(
                fontSize: 18.sp,
                height: 1.95,
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),



          SizedBox(height: 12.h),

          // Bottom Action Bar: Copy Button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  Iconsax.copy,
                  size: 18.r,
                  color: colors.textSecondary,
                ),
                onPressed: () => _copyHadith(context),
                tooltip: 'نسخ الحديث',
                constraints: const BoxConstraints(),
                padding: EdgeInsets.all(6.r),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

