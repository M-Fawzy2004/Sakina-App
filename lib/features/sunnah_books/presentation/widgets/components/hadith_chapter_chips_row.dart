import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_chapter_entity.dart';

class HadithChapterChipsRow extends StatelessWidget {
  final List<SunnahChapterEntity> chapters;
  final int? selectedChapterId;
  final ValueChanged<int?> onChapterSelected;

  const HadithChapterChipsRow({
    super.key,
    required this.chapters,
    required this.selectedChapterId,
    required this.onChapterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isAllSelected = selectedChapterId == null || selectedChapterId == 0;

    final allChips = <Widget>[
      _ChapterChip(
        label: 'جميع الأبواب',
        isSelected: isAllSelected,
        onTap: () {
          HapticService.selectionClick();
          onChapterSelected(null);
        },
      ),
      ...chapters.map((chapter) {
        final isSelected = selectedChapterId == chapter.id;
        return _ChapterChip(
          label: chapter.arabic,
          isSelected: isSelected,
          onTap: () {
            HapticService.selectionClick();
            onChapterSelected(chapter.id);
          },
        );
      }),
    ];

    final row1 = <Widget>[];
    final row2 = <Widget>[];

    for (int i = 0; i < allChips.length; i++) {
      if (i.isEven) {
        row1.add(allChips[i]);
      } else {
        row2.add(allChips[i]);
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < row1.length; i++) ...[
                  if (i > 0) SizedBox(width: 8.w),
                  row1[i],
                ],
              ],
            ),
            SizedBox(height: 5.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < row2.length; i++) ...[
                  if (i > 0) SizedBox(width: 8.w),
                  row2[i],
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChapterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChapterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.accentGold.withValues(alpha: 0.16)
              : colors.background,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? colors.accentGold : colors.borderHairline.withValues(alpha: 0.7),
            width: isSelected ? 1.2.r : 0.8.r,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.accentGold.withValues(alpha: 0.18),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.captionOf(context).copyWith(
            color: isSelected ? colors.accentGold : colors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 11.sp,
          ),
        ),
      ),
    );
  }
}
