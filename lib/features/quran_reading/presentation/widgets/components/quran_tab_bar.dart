import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_state.dart';

/// Refined stadium capsule segmented tab bar matching the user's design reference:
/// Contains 4 plural tabs («السور», «الأجزاء», «الأحزاب», «الصفحات») inside a floating rounded
/// container with smooth animated pill selection, clean typography, and tactile feedback.
class QuranTabBar extends StatelessWidget {
  final QuranTab selectedTab;
  final ValueChanged<QuranTab> onTabSelected;

  const QuranTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 48.h,
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: colors.borderHairline,
            width: 1.r,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: _TabPillItem(
                title: 'السور',
                isSelected: selectedTab == QuranTab.surahs,
                onTap: () {
                  HapticService.selectionClick();
                  onTabSelected(QuranTab.surahs);
                },
              ),
            ),
            Expanded(
              child: _TabPillItem(
                title: 'الأجزاء',
                isSelected: selectedTab == QuranTab.juzs,
                onTap: () {
                  HapticService.selectionClick();
                  onTabSelected(QuranTab.juzs);
                },
              ),
            ),
            Expanded(
              child: _TabPillItem(
                title: 'الأحزاب',
                isSelected: selectedTab == QuranTab.hizbs,
                onTap: () {
                  HapticService.selectionClick();
                  onTabSelected(QuranTab.hizbs);
                },
              ),
            ),
            Expanded(
              child: _TabPillItem(
                title: 'الصفحات',
                isSelected: selectedTab == QuranTab.page,
                onTap: () {
                  HapticService.selectionClick();
                  onTabSelected(QuranTab.page);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabPillItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabPillItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOutCubic,
          decoration: BoxDecoration(
            color: isSelected ? colors.accentGold : Colors.transparent,
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Center(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: isSelected
                  ? AppTextStyles.tabActiveText.copyWith(
                      color: colors.background,
                      fontSize: 12.sp,
                    )
                  : AppTextStyles.tabInactiveText.copyWith(
                      color: colors.textSecondary,
                      fontSize: 12.sp,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
