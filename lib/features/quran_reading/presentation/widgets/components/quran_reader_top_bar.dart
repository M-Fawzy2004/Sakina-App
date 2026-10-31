import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/utils/surah_metadata_utils.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';

/// Top bar for the sacred Quran reader view matching the illuminated manuscript reference:
/// - Left: Frosted circle button with back chevron `<` (Iconsax.arrow_left_2)
/// - Center: Dropdown capsule button with calligraphic Surah title and chevron `⌄` (Iconsax.arrow_down_1)
/// - Right: Frosted circle button with settings gear `⚙` (Iconsax.setting_2)
class QuranReaderTopBar extends StatelessWidget {
  final SurahEntity surah;
  final VoidCallback onClose;
  final VoidCallback onOpenSurahSwitch;
  final VoidCallback onOpenSettings;
  final Color? accentColor;
  final Color? cardColor;

  const QuranReaderTopBar({
    super.key,
    required this.surah,
    required this.onClose,
    required this.onOpenSurahSwitch,
    required this.onOpenSettings,
    this.accentColor,
    this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final activeAccent = accentColor ?? AppColors.champagneGold;
    final calligraphicTitle = SurahMetadataUtils.getCalligraphicSurahName(
      surah.id,
      surah.nameArabic,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Circular Back Button `<`
          _FrostedCircleButton(
            icon: Iconsax.arrow_right_3,
            accentColor: activeAccent,
            cardColor: cardColor,
            onTap: onClose,
          ),

          // Center: Capsule Surah Dropdown Selector
          _SurahCapsuleSelector(
            title: calligraphicTitle,
            accentColor: activeAccent,
            cardColor: cardColor,
            onTap: onOpenSurahSwitch,
          ),

          // Right: Circular Settings Button `⚙`
          _FrostedCircleButton(
            icon: Iconsax.setting_2,
            accentColor: activeAccent,
            cardColor: cardColor,
            onTap: onOpenSettings,
          ),
        ],
      ),
    );
  }
}

class _FrostedCircleButton extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final Color? cardColor;
  final VoidCallback onTap;

  const _FrostedCircleButton({
    required this.icon,
    required this.accentColor,
    this.cardColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.selectionClick();
          onTap();
        },
        customBorder: const CircleBorder(),
        child: Container(
          width: 45.r,
          height: 45.r,
          decoration: BoxDecoration(
            color: (cardColor ?? AppColors.carbonSlate).withValues(alpha: 0.85),
            shape: BoxShape.circle,
            border: Border.all(
              color: accentColor.withValues(alpha: 0.5),
              width: 1.r,
            ),
          ),
          child: Center(
            child: Icon(icon, color: accentColor, size: 18.r),
          ),
        ),
      ),
    );
  }
}

class _SurahCapsuleSelector extends StatelessWidget {
  final String title;
  final Color accentColor;
  final Color? cardColor;
  final VoidCallback onTap;

  const _SurahCapsuleSelector({
    required this.title,
    required this.accentColor,
    this.cardColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(25.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
          decoration: BoxDecoration(
            color: (cardColor ?? AppColors.carbonSlate).withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.6),
              width: 1.r,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5.sp,
                ),
              ),
              SizedBox(width: 6.w),
              Icon(Iconsax.arrow_down_1, color: accentColor, size: 18.r),
            ],
          ),
        ),
      ),
    );
  }
}
