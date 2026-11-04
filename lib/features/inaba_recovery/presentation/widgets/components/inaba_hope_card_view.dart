import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/daily_hope_dose_entity.dart';

/// Renders the Quranic hope dose manuscript card with dynamic background,
/// designed for on-screen viewing and high-resolution export.
class InabaHopeCardView extends StatelessWidget {
  final GlobalKey cardKey;
  final DailyHopeDoseEntity activeDose;
  final String? selectedBackground;

  const InabaHopeCardView({
    super.key,
    required this.cardKey,
    required this.activeDose,
    required this.selectedBackground,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return RepaintBoundary(
      key: cardKey,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 18.h,
        ),
        decoration: BoxDecoration(
          color: selectedBackground == null
              ? colors.surfaceElevated
              : AppColors.obsidianCore,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: colors.accentGold.withValues(alpha: 0.55),
            width: 1.2.r,
          ),
          image: selectedBackground != null
              ? DecorationImage(
                  image: AssetImage(selectedBackground!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    AppColors.obsidianCore.withValues(alpha: 0.65),
                    BlendMode.darken,
                  ),
                )
              : null,
        ),
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FlutterIslamicIcons.quran2,
                  size: 28.r,
                  color: colors.accentGold,
                ),
                SizedBox(height: 12.h),

                // Quotation / Ayah
                Text(
                  activeDose.quotation,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.quranAyahOf(context).copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.9,
                    color: AppColors.pureChalk,
                  ),
                ),
                SizedBox(height: 10.h),

                // Source Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: colors.cardSurface.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: colors.accentGold.withValues(alpha: 0.5),
                      width: 0.8.r,
                    ),
                  ),
                  child: Text(
                    activeDose.source,
                    style: AppTextStyles.captionOf(context).copyWith(
                      color: colors.accentGold,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
                SizedBox(height: 14.h),

                // Explanation
                Text(
                  activeDose.explanation,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMediumOf(context).copyWith(
                    fontSize: 12.5.sp,
                    height: 1.6,
                    color: colors.textPrimary.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: 14.h),

                // Watermark branding on exported card
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FlutterIslamicIcons.solidCrescentMoon,
                      size: 11.r,
                      color: colors.accentGold.withValues(alpha: 0.85),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'تطبيق سَكِينَة 🌿',
                      style: GoogleFonts.almarai(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.bold,
                        color: colors.accentGold.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

