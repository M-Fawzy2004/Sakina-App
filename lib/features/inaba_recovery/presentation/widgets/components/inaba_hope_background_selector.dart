import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';

/// Thumbnail selector component for choosing the Quranic hope card background.
class InabaHopeBackgroundSelector extends StatelessWidget {
  final String? selectedAsset;
  final ValueChanged<String?> onSelect;

  static const List<String> backgroundAssets = [
    'assets/images/background_1.jpg',
    'assets/images/background_2.jpg',
    'assets/images/background_3.jpg',
    'assets/images/background_4.jpg',
  ];

  const InabaHopeBackgroundSelector({
    super.key,
    required this.selectedAsset,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Iconsax.gallery,
              size: 14.r,
              color: colors.accentGold,
            ),
            SizedBox(width: 6.w),
            Text(
              'خلفية البطاقة:',
              style: GoogleFonts.almarai(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w700,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 48.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              // Option 0: Default Dark Luxury
              _ThumbnailItem(
                isSelected: selectedAsset == null,
                onTap: () => onSelect(null),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Icon(
                      Iconsax.brush_1,
                      size: 16.r,
                      color: selectedAsset == null
                          ? colors.accentGold
                          : colors.textSecondary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),

              // Options 1 to 4: The 4 Background Images
              for (int i = 0; i < backgroundAssets.length; i++) ...[
                _ThumbnailItem(
                  isSelected: selectedAsset == backgroundAssets[i],
                  onTap: () => onSelect(backgroundAssets[i]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.asset(
                      backgroundAssets[i],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                if (i < backgroundAssets.length - 1) SizedBox(width: 8.w),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ThumbnailItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;

  const _ThumbnailItem({
    required this.isSelected,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 48.h,
        height: 48.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? colors.accentGold
                : colors.borderHairline.withValues(alpha: 0.6),
            width: isSelected ? 2.r : 1.r,
          ),
        ),
        padding: EdgeInsets.all(2.r),
        child: Stack(
          children: [
            Positioned.fill(child: child),
            if (isSelected)
              Positioned(
                top: 2.r,
                right: 2.r,
                child: Container(
                  padding: EdgeInsets.all(2.r),
                  decoration: BoxDecoration(
                    color: colors.accentGold,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.tick_circle,
                    size: 10.r,
                    color: colors.background,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

