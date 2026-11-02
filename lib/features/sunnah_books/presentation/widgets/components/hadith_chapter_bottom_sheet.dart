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
            return c.arabic.contains(_filter);
          }).toList();

    final totalGridItems = filteredChapters.length + 1;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 0.82.sh,
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 14.h,
          bottom: bottomInset > 0 ? bottomInset + 12.h : 20.h,
        ),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          border: Border.all(
            color: colors.borderHairline.withValues(alpha: 0.7),
            width: 1.r,
          ),
        ),
        child: Column(
          children: [
            // Top Handle
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
            SizedBox(height: 12.h),

            // Header Title & Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'فهرس أبواب الكتاب',
                  style: AppTextStyles.titleMediumOf(context).copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: colors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Iconsax.close_circle,
                    size: 20.r,
                    color: colors.textSecondary,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'إغلاق',
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Filter Search Bar
            Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: colors.borderHairline.withValues(alpha: 0.7),
                  width: 0.8.r,
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
            SizedBox(height: 12.h),

            // 2-Column Chapters Grid
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: totalGridItems,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.3,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                ),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    final isAll = widget.selectedChapterId == null || widget.selectedChapterId == 0;
                    return _GridChapterTile(
                      badge: 'الكل',
                      title: 'جميع الأبواب',
                      isSelected: isAll,
                      onTap: () {
                        HapticService.selectionClick();
                        widget.onChapterSelected(null);
                        Navigator.of(context).pop();
                      },
                    );
                  }

                  final ch = filteredChapters[index - 1];
                  final isSelected = widget.selectedChapterId == ch.id;

                  return _GridChapterTile(
                    badge: '#${ch.id}',
                    title: ch.arabic,
                    isSelected: isSelected,
                    onTap: () {
                      HapticService.selectionClick();
                      widget.onChapterSelected(ch.id);
                      Navigator.of(context).pop();
                    },
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

class _GridChapterTile extends StatelessWidget {
  final String badge;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _GridChapterTile({
    required this.badge,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.accentGold.withValues(alpha: 0.14)
              : colors.background,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? colors.accentGold
                : colors.borderHairline.withValues(alpha: 0.6),
            width: isSelected ? 1.2.r : 0.8.r,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.accentGold.withValues(alpha: 0.2)
                    : colors.borderHairline.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                badge,
                style: AppTextStyles.captionOf(context).copyWith(
                  color: isSelected ? colors.accentGold : colors.textSecondary,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.captionOf(context).copyWith(
                  color: isSelected ? colors.accentGold : colors.textPrimary,
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
