import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/sunnah_books/domain/entities/sunnah_chapter_entity.dart';

class HadithChapterBottomSheet extends StatefulWidget {
  final List<SunnahChapterEntity> chapters;
  final int? selectedChapterId;
  final ValueChanged<int?> onChapterSelected;

  const HadithChapterBottomSheet({
    super.key,
    required this.chapters,
    required this.selectedChapterId,
    required this.onChapterSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required List<SunnahChapterEntity> chapters,
    required int? selectedChapterId,
    required ValueChanged<int?> onChapterSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (_) => HadithChapterBottomSheet(
        chapters: chapters,
        selectedChapterId: selectedChapterId,
        onChapterSelected: onChapterSelected,
      ),
    );
  }

  @override
  State<HadithChapterBottomSheet> createState() =>
      _HadithChapterBottomSheetState();
}

class _HadithChapterBottomSheetState extends State<HadithChapterBottomSheet> {
  late final TextEditingController _filterController;
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _filterController = TextEditingController();
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final filteredChapters = _filter.isEmpty
        ? widget.chapters
        : widget.chapters.where((c) {
            return c.arabic.contains(_filter) ||
                c.english.toLowerCase().contains(_filter.toLowerCase());
          }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 0.80.sh,
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 14.h,
          bottom: bottomInset > 0 ? bottomInset + 12.h : 20.h,
        ),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          border: Border.all(
            color: colors.borderHairline,
            width: 1.r,
          ),
        ),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.borderHairline,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 14.h),

            // Header Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'أبواب وفصول الكتاب',
                  style: AppTextStyles.titleMediumOf(context).copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  '${widget.chapters.length} باباً',
                  style: AppTextStyles.captionOf(context).copyWith(
                    color: colors.accentGold,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Search filter field
            Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: colors.borderHairline,
                  width: 1.r,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: 12.w),
                  Icon(
                    Iconsax.search_normal_1,
                    size: 16.r,
                    color: colors.textSecondary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: _filterController,
                      onChanged: (val) {
                        setState(() {
                          _filter = val.trim();
                        });
                      },
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: colors.textPrimary,
                        fontSize: 12.5.sp,
                      ),
                      decoration: InputDecoration(
                        hintText: 'ابحث في أسماء الأبواب...',
                        hintStyle: AppTextStyles.captionOf(context).copyWith(
                          color: colors.textSecondary,
                          fontSize: 11.5.sp,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (_filter.isNotEmpty)
                    IconButton(
                      icon: Icon(
                        Iconsax.close_circle,
                        size: 16.r,
                        color: colors.textSecondary,
                      ),
                      onPressed: () {
                        _filterController.clear();
                        setState(() {
                          _filter = '';
                        });
                      },
                    )
                  else
                    SizedBox(width: 10.w),
                ],
              ),
            ),
            SizedBox(height: 10.h),

            // "جميع الأبواب" Tile
            InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: () {
                HapticService.selectionClick();
                widget.onChapterSelected(null);
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: widget.selectedChapterId == null
                      ? colors.accentGold.withValues(alpha: 0.14)
                      : colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: widget.selectedChapterId == null
                        ? colors.accentGold
                        : colors.borderHairline,
                    width: 1.r,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.book,
                      size: 16.r,
                      color: widget.selectedChapterId == null
                          ? colors.accentGold
                          : colors.textSecondary,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'جميع الأبواب (عرض كامل الكتاب)',
                      style: AppTextStyles.captionOf(context).copyWith(
                        color: widget.selectedChapterId == null
                            ? colors.accentGold
                            : colors.textPrimary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),

            // Chapters List
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: filteredChapters.length,
                separatorBuilder: (_, _) => SizedBox(height: 6.h),
                itemBuilder: (context, index) {
                  final ch = filteredChapters[index];
                  final isSelected = widget.selectedChapterId == ch.id;

                  return InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: () {
                      HapticService.selectionClick();
                      widget.onChapterSelected(ch.id);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.accentGold.withValues(alpha: 0.12)
                            : colors.cardSurface,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected ? colors.accentGold : colors.borderHairline,
                          width: isSelected ? 1.2.r : 0.8.r,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 26.r,
                            height: 26.r,
                            decoration: BoxDecoration(
                              color: colors.surfaceElevated,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Text(
                                '${ch.id}',
                                style: AppTextStyles.captionOf(context).copyWith(
                                  color: isSelected ? colors.accentGold : colors.textSecondary,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              ch.arabic,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.captionOf(context).copyWith(
                                color: isSelected ? colors.accentGold : colors.textPrimary,
                                fontSize: 12.sp,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

