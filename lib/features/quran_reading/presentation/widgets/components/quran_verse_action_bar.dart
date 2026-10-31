import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Contextual floating action bar for an active Ayah matching Screen 2 in the mockup:
/// Provides [ play | copy | bookmark | reflection ] controls in a sleek translucent stadium pill.
class QuranVerseActionBar extends StatelessWidget {
  final VoidCallback onPlay;
  final VoidCallback onCopy;
  final VoidCallback onBookmark;
  final VoidCallback onReflection;

  const QuranVerseActionBar({
    super.key,
    required this.onPlay,
    required this.onCopy,
    required this.onBookmark,
    required this.onReflection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.carbonSlate.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppColors.champagneGold,
          width: 1.r,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1. Play Recitation
          _ActionPillItem(
            icon: Iconsax.play,
            label: 'play',
            subLabel: 'تلاوة',
            onTap: onPlay,
          ),

          const _VerseActionDivider(),

          // 2. Copy Verse Text
          _ActionPillItem(
            icon: Iconsax.copy,
            label: 'copy',
            subLabel: 'نسخ',
            onTap: onCopy,
          ),

          const _VerseActionDivider(),

          // 3. Bookmark
          _ActionPillItem(
            icon: Iconsax.bookmark,
            label: 'bookmark',
            subLabel: 'حفظ',
            onTap: onBookmark,
          ),

          const _VerseActionDivider(),

          // 4. Tafsir & Reflection
          _ActionPillItem(
            icon: Iconsax.book_1,
            label: 'reflection',
            subLabel: 'تدبر',
            isHighlighted: true,
            onTap: onReflection,
          ),
        ],
      ),
    );
  }
}

class _VerseActionDivider extends StatelessWidget {
  const _VerseActionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.w,
      height: 18.h,
      color: AppColors.goldBorderStroke,
    );
  }
}

class _ActionPillItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subLabel;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _ActionPillItem({
    required this.icon,
    required this.label,
    required this.subLabel,
    this.isHighlighted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor =
        isHighlighted ? AppColors.emeraldGlow : AppColors.champagneGold;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(16.r),
        splashColor: activeColor.withValues(alpha: 0.15),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: activeColor,
                size: 15.r,
              ),
              SizedBox(width: 4.w),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: isHighlighted
                      ? AppColors.emeraldGlow
                      : AppColors.pureChalk,
                  fontWeight: FontWeight.w600,
                  fontSize: 11.5.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
