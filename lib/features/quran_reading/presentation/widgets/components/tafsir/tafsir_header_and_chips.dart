import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/ayah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/tafsir_entity.dart';

/// Center-aligned drag handle pill for sheet gesture dismissal.
class TafsirSheetDragHandle extends StatelessWidget {
  const TafsirSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 6.h),
      child: Center(
        child: Container(
          width: 42.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: colors.textSecondary.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ),
    );
  }
}

/// Header row presenting Ayah number badge, Surah title, and close button.
class TafsirHeader extends StatelessWidget {
  final SurahEntity surah;
  final AyahEntity ayah;
  final VoidCallback onClose;

  const TafsirHeader({
    super.key,
    required this.surah,
    required this.ayah,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 34.r,
                height: 34.r,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.accentGold,
                    width: 1.r,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${ayah.numberInSurah}',
                    style: AppTextStyles.caption.copyWith(
                      color: colors.accentGold,
                      fontWeight: FontWeight.w800,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سُورَةُ ${surah.nameArabic}',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                    ),
                  ),
                  Text(
                    'الآية ${ayah.numberInSurah} • صَفْحَةُ ${ayah.page} • جُزْءُ ${ayah.juz}',
                    style: AppTextStyles.caption.copyWith(
                      color: colors.accentGold,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: onClose,
            icon: Icon(
              Iconsax.close_circle,
              color: colors.textSecondary,
              size: 22.r,
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal selector chips for Tafsir schools (المختصر، السعدي، الجلالين).
class TafsirTypeChips extends StatelessWidget {
  final List<TafsirEntity> tafsirs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const TafsirTypeChips({
    super.key,
    required this.tafsirs,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(tafsirs.length, (index) {
          final isSelected = index == selectedIndex;
          final item = tafsirs[index];

          return Padding(
            padding: EdgeInsetsDirectional.only(end: 8.w),
            child: InkWell(
              onTap: () {
                HapticService.selectionClick();
                onSelected(index);
              },
              borderRadius: BorderRadius.circular(10.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors.accentEmerald.withValues(alpha: 0.16)
                      : colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: isSelected
                        ? colors.accentEmerald
                        : colors.borderHairline,
                    width: isSelected ? 1.2.r : 0.8.r,
                  ),
                ),
                child: Text(
                  item.type,
                  style: AppTextStyles.caption.copyWith(
                    color: isSelected
                        ? colors.accentEmerald
                        : colors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 11.5.sp,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

