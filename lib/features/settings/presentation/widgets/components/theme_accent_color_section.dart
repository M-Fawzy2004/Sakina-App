import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/settings/domain/entities/app_accent_color.dart';

/// Curated Jewel Palette for Primary Accent Color Selection.
class ThemeAccentColorSection extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<AppAccentColor> onColorSelected;

  const ThemeAccentColorSection({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.65),
          width: 1.r,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: colors.borderHairline.withValues(alpha: 0.5),
                    width: 0.8.r,
                  ),
                ),
                child: Icon(
                  Iconsax.colorfilter,
                  size: 16.r,
                  color: colors.accentGold,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'لَوْنُ التَّمْيِيزِ الأَسَاسِيُّ (Primary Accent)',
                      style: GoogleFonts.cairo(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      'يتحكم في إضاءة الآيات، أزرار التبويبات، واللمسات الملكية',
                      style: GoogleFonts.cairo(
                        fontSize: 11.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Horizontal Palette of Jewels
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            alignment: WrapAlignment.center,
            children: AppAccentColor.allAccents.map((accent) {
              final isSelected =
                  accent.color.toARGB32() == selectedColor.toARGB32();

              return InkWell(
                onTap: () => onColorSelected(accent),
                borderRadius: BorderRadius.circular(28.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: accent.color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 2.2.r,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: accent.color.withValues(alpha: 0.55),
                                  blurRadius: 10.r,
                                  spreadRadius: 2.r,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check_rounded,
                              size: 22.r,
                              color: accent.color.computeLuminance() > 0.5
                                  ? Colors.black87
                                  : Colors.white,
                            )
                          : null,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      accent.title.split(' ').first,
                      style: GoogleFonts.cairo(
                        fontSize: 10.5.sp,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? colors.textPrimary
                            : colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

