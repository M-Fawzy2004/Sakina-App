import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_state.dart';

/// Refined stadium capsule segmented tab bar matching the user's design reference:
/// Contains 4 tabs («الصَّفْحَة», «السُّورَة», «الجُزْء», «الحِزْب») inside a floating rounded
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 48.h,
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: AppColors.carbonSlate,
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: AppColors.goldBorderStroke.withValues(alpha: 0.3),
            width: 1.r,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: _TabPillItem(
                title: 'الصَّفْحَة',
                isSelected: selectedTab == QuranTab.page,
                onTap: () {
                  HapticService.selectionClick();
                  onTabSelected(QuranTab.page);
                },
              ),
            ),
            Expanded(
              child: _TabPillItem(
                title: 'السُّورَة',
                isSelected: selectedTab == QuranTab.surahs,
                onTap: () {
                  HapticService.selectionClick();
                  onTabSelected(QuranTab.surahs);
                },
              ),
            ),
            Expanded(
              child: _TabPillItem(
                title: 'الجُزْء',
                isSelected: selectedTab == QuranTab.juzs,
                onTap: () {
                  HapticService.selectionClick();
                  onTabSelected(QuranTab.juzs);
                },
              ),
            ),
            Expanded(
              child: _TabPillItem(
                title: 'الحِزْب',
                isSelected: selectedTab == QuranTab.hizbs ||
                    selectedTab == QuranTab.bookmarks,
                onTap: () {
                  HapticService.selectionClick();
                  onTabSelected(QuranTab.hizbs);
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOutCubic,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.champagneGold : Colors.transparent,
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Center(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: isSelected
                  ? AppTextStyles.tabActiveText
                  : AppTextStyles.tabInactiveText,
            ),
          ),
        ),
      ),
    );
  }
}
