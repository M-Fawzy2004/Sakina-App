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

    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: chapters.length + 1,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _ChapterChip(
              label: 'جميع الأبواب',
              isSelected: isAllSelected,
              onTap: () {
                HapticService.selectionClick();
                onChapterSelected(null);
              },
            );
          }

          final chapter = chapters[index - 1];
          final isSelected = selectedChapterId == chapter.id;

          return _ChapterChip(
            label: chapter.arabic,
            isSelected: isSelected,
            onTap: () {
              HapticService.selectionClick();
              onChapterSelected(chapter.id);
            },
          );
        },
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
      borderRadius: BorderRadius.circular(10.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.accentGold.withValues(alpha: 0.16)
              : colors.surfaceElevated,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? colors.accentGold
                : colors.borderHairline,
            width: isSelected ? 1.2.r : 0.8.r,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.accentGold.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
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
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
