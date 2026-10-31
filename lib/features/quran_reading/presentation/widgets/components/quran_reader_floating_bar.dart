import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Floating interactive stadium menu for Al-Mushaf reader:
/// Replaces the old rectangular bottom bar with a floating action bar that operates:
/// - On the currently selected Ayah if one is highlighted, OR
/// - On the entire current page/Surah if no ayah is highlighted.
class QuranReaderFloatingBar extends StatelessWidget {
  final int pageNumber;
  final int juzNumber;
  final int? selectedAyahNumber;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final VoidCallback onPlay;
  final VoidCallback onTafsir;
  final VoidCallback onCopy;
  final VoidCallback onBookmark;

  const QuranReaderFloatingBar({
    super.key,
    required this.pageNumber,
    required this.juzNumber,
    required this.selectedAyahNumber,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.onPlay,
    required this.onTafsir,
    required this.onCopy,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedAyahNumber != null;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.carbonSlate.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppColors.goldBorderStroke,
          width: 1.2.r,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Row: Page Navigation & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous Page
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  HapticService.selectionClick();
                  onPreviousPage();
                },
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.champagneGold,
                  size: 24.r,
                ),
              ),

              // Page & Juz Info or Active Ayah Badge
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ص $pageNumber • الجزء $juzNumber',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.champagneGold,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.5.sp,
                    ),
                  ),
                  if (hasSelection) ...[
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.emeraldGlow.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.emeraldGlow,
                          width: 0.8.r,
                        ),
                      ),
                      child: Text(
                        'الآية $selectedAyahNumber',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.emeraldGlow,
                          fontWeight: FontWeight.w700,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              // Next Page
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  HapticService.selectionClick();
                  onNextPage();
                },
                icon: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.champagneGold,
                  size: 24.r,
                ),
              ),
            ],
          ),

          Divider(
            color: AppColors.goldBorderStroke.withValues(alpha: 0.3),
            height: 10.h,
          ),

          // Bottom Row: Action Buttons (Play, Tafsir, Copy, Bookmark)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _FloatingActionItem(
                icon: Icons.play_arrow_rounded,
                label: 'تِلَاوَة',
                onTap: onPlay,
              ),
              _FloatingActionItem(
                icon: HugeIcons.strokeRoundedBookOpen01,
                label: 'تَفْسِير',
                isHighlighted: true,
                onTap: onTafsir,
              ),
              _FloatingActionItem(
                icon: Icons.copy_rounded,
                label: 'نَسْخ',
                onTap: onCopy,
              ),
              _FloatingActionItem(
                icon: Icons.bookmark_add_rounded,
                label: 'حِفْظ',
                onTap: onBookmark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FloatingActionItem extends StatelessWidget {
  final dynamic icon;
  final String label;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _FloatingActionItem({
    required this.icon,
    required this.label,
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
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon is IconData)
                Icon(
                  icon as IconData,
                  color: activeColor,
                  size: 15.r,
                )
              else if (icon is List<List<dynamic>>)
                HugeIcon(
                  icon: icon as List<List<dynamic>>,
                  color: activeColor,
                  size: 14.r,
                ),
              SizedBox(width: 4.w),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: isHighlighted
                      ? AppColors.emeraldGlow
                      : AppColors.pureChalk,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

