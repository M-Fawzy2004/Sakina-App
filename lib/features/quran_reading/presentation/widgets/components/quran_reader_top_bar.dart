import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/utils/surah_metadata_utils.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';

/// Top bar for the sacred Quran reader view matching the illuminated manuscript reference:
/// - Left: Frosted circle button with back chevron `<`
/// - Center: Dropdown capsule button with calligraphic Surah title and chevron `⌄`
/// - Right: Frosted circle button with settings gear `⚙`
class QuranReaderTopBar extends StatelessWidget {
  final SurahEntity surah;
  final VoidCallback onClose;
  final VoidCallback onOpenSurahSwitch;
  final VoidCallback onOpenSettings;

  const QuranReaderTopBar({
    super.key,
    required this.surah,
    required this.onClose,
    required this.onOpenSurahSwitch,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
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
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onClose,
          ),

          // Center: Capsule Surah Dropdown Selector
          _SurahCapsuleSelector(
            title: calligraphicTitle,
            onTap: onOpenSurahSwitch,
          ),

          // Right: Circular Settings Button `⚙`
          _FrostedCircleButton(icon: Iconsax.setting_2, onTap: onOpenSettings),
        ],
      ),
    );
  }
}

class _FrostedCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _FrostedCircleButton({required this.icon, required this.onTap});

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
        splashColor: AppColors.goldGlowSoft,
        child: Container(
          width: 45.r,
          height: 45.r,
          decoration: BoxDecoration(
            color: AppColors.carbonSlate.withValues(alpha: 0.75),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.goldBorderStroke.withValues(alpha: 0.5),
              width: 1.r,
            ),
          ),
          child: Center(
            child: Icon(icon, color: AppColors.champagneGold, size: 18.r),
          ),
        ),
      ),
    );
  }
}

class _SurahCapsuleSelector extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _SurahCapsuleSelector({required this.title, required this.onTap});

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
        splashColor: AppColors.goldGlowSoft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
          decoration: BoxDecoration(
            color: AppColors.carbonSlate.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(
              color: AppColors.goldBorderStroke.withValues(alpha: 0.6),
              width: 1.r,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.champagneGold,
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5.sp,
                ),
              ),
              SizedBox(width: 6.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.champagneGold,
                size: 20.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
