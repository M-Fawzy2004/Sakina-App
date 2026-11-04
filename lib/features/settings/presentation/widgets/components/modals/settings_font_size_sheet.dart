import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Modal bottom sheet for customizing application-wide typography scale
/// with live scripture/dhikr preview and safe area immunity above the bottom bar.
class SettingsFontSizeSheet extends StatefulWidget {
  final double currentScale;
  final ValueChanged<double> onScaleSelected;

  const SettingsFontSizeSheet({
    super.key,
    required this.currentScale,
    required this.onScaleSelected,
  });

  static Future<void> show({
    required BuildContext context,
    required double currentScale,
    required ValueChanged<double> onScaleSelected,
  }) {
    HapticService.selectionClick();
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SettingsFontSizeSheet(
        currentScale: currentScale,
        onScaleSelected: onScaleSelected,
      ),
    );
  }

  @override
  State<SettingsFontSizeSheet> createState() => _SettingsFontSizeSheetState();
}

class _SettingsFontSizeSheetState extends State<SettingsFontSizeSheet> {
  late double _selectedScale;

  static const List<_FontScalePreset> _presets = [
    _FontScalePreset(scale: 0.90, label: 'صغير', desc: 'مقتصد 90%'),
    _FontScalePreset(scale: 1.00, label: 'معتدل', desc: 'متوازن 100%'),
    _FontScalePreset(scale: 1.10, label: 'مريح', desc: 'موصى به 110%'),
    _FontScalePreset(scale: 1.20, label: 'كبير', desc: 'واضح 120%'),
    _FontScalePreset(scale: 1.30, label: 'جلي جداً', desc: 'مكبر 130%'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedScale = widget.currentScale;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
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

            // Sheet Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.textalign_justifycenter,
                  size: 20.r,
                  color: colors.accentGold,
                ),
                SizedBox(width: 8.w),
                Text(
                  'حَجْمُ خَطِّ التَّطْبِيقِ وَالنُّصُوصِ',
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),

            // Live Text Sample Preview Box
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
                    '«سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ»',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amiri(
                      fontSize: (22.0 * _selectedScale).sp,
                      color: colors.accentGold,
                      height: 1.7,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'معاينة حية لنصوص وأذكار سكينة (${(_selectedScale * 100).toInt()}%)',
                    style: GoogleFonts.cairo(
                      fontSize: 11.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Preset Selection Buttons (Capsule style)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _presets.map((preset) {
                final isSelected = (_selectedScale - preset.scale).abs() < 0.01;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.5.w),
                    child: InkWell(
                      onTap: () {
                        HapticService.selectionClick();
                        setState(() => _selectedScale = preset.scale);
                      },
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.accentGold.withValues(alpha: 0.16)
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
                            SizedBox(height: 2.h),
                            Text(
                              '${(preset.scale * 100).toInt()}%',
                              style: GoogleFonts.cairo(
                                fontSize: 9.sp,
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
                  widget.onScaleSelected(_selectedScale);
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
                  'تَطْبِيقُ الخَطِّ عَلَى التَّطْبِيقِ',
                  style: GoogleFonts.cairo(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FontScalePreset {
  final double scale;
  final String label;
  final String desc;

  const _FontScalePreset({
    required this.scale,
    required this.label,
    required this.desc,
  });
}
