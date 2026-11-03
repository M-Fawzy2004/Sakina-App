import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/istighfar/domain/entities/istighfar_item.dart';

/// Horizontal ribbon of chips allowing seamless selection between various
/// Istighfar and Tasbeeh categories with active golden highlight.
class IstighfarSelectorChips extends StatelessWidget {
  final List<IstighfarItem> items;
  final String selectedItemId;
  final ValueChanged<String> onItemSelected;

  const IstighfarSelectorChips({
    super.key,
    required this.items,
    required this.selectedItemId,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = item.id == selectedItemId;

          return _ChipItem(
            item: item,
            isSelected: isSelected,
            onTap: () => onItemSelected(item.id),
          );
        },
      ),
    );
  }
}

class _ChipItem extends StatelessWidget {
  final IstighfarItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChipItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isSelected ? colors.accentGold : colors.cardSurface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? colors.accentGold
                : colors.borderHairline.withValues(alpha: 0.6),
            width: isSelected ? 1.4.r : 0.8.r,
          ),
        ),
        child: Center(
          child: Text(
            item.shortTitle,
            style: GoogleFonts.almarai(
              color: isSelected
                  ? (colors.isDark ? AppColors.obsidianCore : AppColors.inkDeep)
                  : colors.textSecondary,
              fontSize: 12.5.sp,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
