import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/arabic_text_utils.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';

/// Quick Surah Switch Bottom Sheet allowing fast navigation between all 114 Surahs.
class QuranSurahQuickSwitchSheet extends StatefulWidget {
  final int currentSurahId;
  final List<SurahEntity> allSurahs;
  final ValueChanged<SurahEntity> onSurahSelected;

  const QuranSurahQuickSwitchSheet({
    super.key,
    required this.currentSurahId,
    required this.allSurahs,
    required this.onSurahSelected,
  });

  @override
  State<QuranSurahQuickSwitchSheet> createState() =>
      _QuranSurahQuickSwitchSheetState();
}

class _QuranSurahQuickSwitchSheetState
    extends State<QuranSurahQuickSwitchSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final normalizedQuery = ArabicTextUtils.normalize(_query.trim());
    final filtered = widget.allSurahs.where((s) {
      if (normalizedQuery.isEmpty) return true;
      final matchAr = ArabicTextUtils.normalize(s.nameArabic)
          .contains(normalizedQuery);
      final matchEn = s.englishName.toLowerCase().contains(
        _query.toLowerCase(),
      );
      final matchId = s.id.toString() == _query.trim();
      return matchAr || matchEn || matchId;
    }).toList();

    return Container(
      height: 480.h,
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(color: colors.borderHairline, width: 1.2.r),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: colors.accentGold.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'فِهْرِسُ السُّوَرِ الكَرِيمَةِ',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: colors.accentGold,
                    fontWeight: FontWeight.w800,
                    fontSize: 15.sp,
                  ),
                ),
                Text(
                  '114 سورة',
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textSecondary,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),

          // Search Field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: TextField(
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'ابحث عن سورة بالاسم أو الرقم...',
                hintStyle: AppTextStyles.caption.copyWith(
                  color: colors.textSecondary,
                ),
                prefixIcon: Icon(
                  Iconsax.search_normal,
                  color: colors.accentGold,
                  size: 20.r,
                ),
                filled: true,
                fillColor: colors.surfaceElevated,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 10.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(
                    color: colors.borderHairline,
                    width: 1.r,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(
                    color: colors.borderHairline.withValues(alpha: 0.4),
                    width: 1.r,
                  ),
                ),
              ),
              onChanged: (val) => setState(() => _query = val),
            ),
          ),

          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              itemCount: filtered.length,
              separatorBuilder: (context, index) => Divider(
                color: colors.borderHairline.withValues(alpha: 0.2),
                height: 1.h,
              ),
              itemBuilder: (context, index) {
                final item = filtered[index];
                final isCurrent = item.id == widget.currentSurahId;

                return _SurahSwitchTile(
                  surah: item,
                  isCurrent: isCurrent,
                  onTap: () => widget.onSurahSelected(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SurahSwitchTile extends StatelessWidget {
  final SurahEntity surah;
  final bool isCurrent;
  final VoidCallback onTap;

  const _SurahSwitchTile({
    required this.surah,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: isCurrent
          ? colors.accentGold.withValues(alpha: 0.15)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: () {
          HapticService.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            children: [
              SizedBox(
                width: 28.w,
                child: Text(
                  '${surah.id}',
                  style: AppTextStyles.caption.copyWith(
                    color: isCurrent
                        ? colors.accentGold
                        : colors.textSecondary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'سُورَةُ ${surah.nameArabic}',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: isCurrent
                            ? colors.accentGold
                            : colors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      '${surah.englishName} • ص ${surah.pageNumber}',
                      style: AppTextStyles.caption.copyWith(
                        color: colors.textSecondary,
                        fontSize: 10.5.sp,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCurrent)
                Icon(
                  Iconsax.tick_circle,
                  color: colors.accentGold,
                  size: 18.r,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
