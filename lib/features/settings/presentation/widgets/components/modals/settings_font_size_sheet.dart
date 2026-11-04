import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Modal bottom sheet for customizing Quranic font size with live verse preview.
class SettingsFontSizeSheet extends StatefulWidget {
  final double currentSize;
  final ValueChanged<double> onSizeSelected;

  const SettingsFontSizeSheet({
    super.key,
    required this.currentSize,
    required this.onSizeSelected,
  });

  static Future<void> show({
    required BuildContext context,
    required double currentSize,
    required ValueChanged<double> onSizeSelected,
  }) {
    HapticService.selectionClick();
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SettingsFontSizeSheet(
        currentSize: currentSize,
        onSizeSelected: onSizeSelected,
      ),
    );
  }

  @override
  State<SettingsFontSizeSheet> createState() => _SettingsFontSizeSheetState();
}

class _SettingsFontSizeSheetState extends State<SettingsFontSizeSheet> {
  late double _selectedSize;

  static const List<_FontSizePreset> _presets = [
    _FontSizePreset(size: 20.0, label: 'صغير', desc: 'مقتصد'),
    _FontSizePreset(size: 24.0, label: 'معتدل', desc: 'متوازن'),
    _FontSizePreset(size: 28.0, label: 'مريح', desc: 'موصى به'),
    _FontSizePreset(size: 32.0, label: 'كبير', desc: 'واضح وجلي'),
    _FontSizePreset(size: 36.0, label: 'جلي جداً', desc: 'مكبر'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.currentSize;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 28.h),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.8),
          width: 1.r,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 38.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: colors.accentGold.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 14.h),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.textalign_justifycenter,
                  size: 20.r, color: colors.accentGold),
              SizedBox(width: 8.w),
              Text(
                'حَجْمُ خَطِّ الآيَاتِ القُرْآنِيَّةِ',
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Live Scripture Preview Box
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: colors.accentGold.withValues(alpha: 0.35),
                width: 1.r,
              ),
            ),
            child: Column(
              children: [
                Text(
                  '«إِنَّ هَٰذَا الْقُرْآنَ يَهْدِي لِلَّتِي هِيَ أَقْوَمُ»',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.amiri(
                    fontSize: _selectedSize.sp,
                    color: colors.accentGold,
                    height: 1.8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'معاينة حية بالحجم المختار (${_selectedSize.toInt()}sp)',
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Preset Chips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _presets.map((preset) {
              final isSelected = _selectedSize == preset.size;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: InkWell(
                    onTap: () {
                      HapticService.selectionClick();
                      setState(() => _selectedSize = preset.size);
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.accentGold.withValues(alpha: 0.15)
                            : colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? colors.accentGold
                              : colors.borderHairline,
                          width: isSelected ? 1.5.r : 0.8.r,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            preset.label,
                            style: GoogleFonts.cairo(
                              fontSize: 11.5.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: isSelected
                                  ? colors.accentGold
                                  : colors.textPrimary,
                            ),
                          ),
                          Text(
                            '${preset.size.toInt()}sp',
                            style: GoogleFonts.cairo(
                              fontSize: 9.5.sp,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20.h),

          // Confirm Action Button
          SizedBox(
            width: double.infinity,
            height: 46.h,
            child: ElevatedButton(
              onPressed: () {
                HapticService.selectionClick();
                widget.onSizeSelected(_selectedSize);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accentGold,
                foregroundColor: colors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'حِفْظُ الحَجْمِ المَطْلُوبِ',
                style: GoogleFonts.cairo(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FontSizePreset {
  final double size;
  final String label;
  final String desc;

  const _FontSizePreset({
    required this.size,
    required this.label,
    required this.desc,
  });
}
