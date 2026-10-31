import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';

/// Luxury bottom sheet for audio player adjustments and timer controls with instant reactive state.
class AudioPlayerSettingsSheet extends StatefulWidget {
  final double currentSpeed;
  final int? sleepTimerMinutes;
  final bool isRepeating;
  final ValueChanged<double> onSpeedSelected;
  final ValueChanged<int?> onSleepTimerSelected;
  final VoidCallback onToggleRepeat;

  const AudioPlayerSettingsSheet({
    super.key,
    required this.currentSpeed,
    required this.sleepTimerMinutes,
    required this.isRepeating,
    required this.onSpeedSelected,
    required this.onSleepTimerSelected,
    required this.onToggleRepeat,
  });

  static Future<void> show({
    required BuildContext context,
    required double currentSpeed,
    required int? sleepTimerMinutes,
    required bool isRepeating,
    required ValueChanged<double> onSpeedSelected,
    required ValueChanged<int?> onSleepTimerSelected,
    required VoidCallback onToggleRepeat,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AudioPlayerSettingsSheet(
        currentSpeed: currentSpeed,
        sleepTimerMinutes: sleepTimerMinutes,
        isRepeating: isRepeating,
        onSpeedSelected: onSpeedSelected,
        onSleepTimerSelected: onSleepTimerSelected,
        onToggleRepeat: onToggleRepeat,
      ),
    );
  }

  @override
  State<AudioPlayerSettingsSheet> createState() => _AudioPlayerSettingsSheetState();
}

class _AudioPlayerSettingsSheetState extends State<AudioPlayerSettingsSheet> {
  late double _activeSpeed;
  late int? _activeSleepTimer;
  late bool _activeIsRepeating;

  @override
  void initState() {
    super.initState();
    _activeSpeed = widget.currentSpeed;
    _activeSleepTimer = widget.sleepTimerMinutes;
    _activeIsRepeating = widget.isRepeating;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(
          color: colors.borderHairline,
          width: 1.r,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag indicator handle
            Center(
              child: Container(
                width: 38.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Header Title
            Row(
              children: [
                Icon(
                  Iconsax.setting_2,
                  color: colors.accentGold,
                  size: 20.r,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'إعدادات التلاوة والمشغل',
                    style: GoogleFonts.cairo(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // 1. Sleep Timer Section
            _SettingsSectionTitle(
              icon: Iconsax.timer_1,
              title: 'مؤقت النوم',
              subtitle: _activeSleepTimer != null
                  ? 'يتوقف بعد $_activeSleepTimer دقيقة'
                  : 'متوقف حالياً',
            ),
            SizedBox(height: 10.h),
            _SleepTimerOptions(
              selectedMinutes: _activeSleepTimer,
              onSelected: (minutes) {
                HapticFeedback.lightImpact();
                setState(() => _activeSleepTimer = minutes);
                widget.onSleepTimerSelected(minutes);
              },
            ),
            SizedBox(height: 20.h),

            // 2. Playback Speed Section
            const _SettingsSectionTitle(
              icon: Iconsax.speedometer,
              title: 'سرعة التلاوة',
              subtitle: 'اختر سرعة الاستماع المناسبة لك (تتغير فورياً)',
            ),
            SizedBox(height: 10.h),
            _SpeedOptions(
              selectedSpeed: _activeSpeed,
              onSelected: (speed) {
                HapticFeedback.lightImpact();
                setState(() => _activeSpeed = speed);
                widget.onSpeedSelected(speed);
              },
            ),
            SizedBox(height: 20.h),

            // 3. Repeat Mode
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => _activeIsRepeating = !_activeIsRepeating);
                widget.onToggleRepeat();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: AppSpacing.radiusMd,
                  border: Border.all(
                    color: _activeIsRepeating ? colors.accentGold : colors.borderHairline,
                    width: 1.r,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.repeate_one,
                            color: _activeIsRepeating ? colors.accentGold : colors.textSecondary,
                            size: 20.r,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              'تكرار التلاوة الحالية تلقائياً',
                              style: GoogleFonts.cairo(
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w600,
                                color: _activeIsRepeating ? colors.accentGold : colors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      _activeIsRepeating ? Iconsax.tick_circle : Iconsax.close_circle,
                      color: _activeIsRepeating ? colors.accentGold : colors.textSecondary,
                      size: 20.r,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 14.h),
          ],
        ),
      ),
    );
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SettingsSectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Icon(icon, color: colors.accentGold, size: 18.r),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.cairo(
                  fontSize: 11.5.sp,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SleepTimerOptions extends StatelessWidget {
  final int? selectedMinutes;
  final ValueChanged<int?> onSelected;

  const _SleepTimerOptions({
    required this.selectedMinutes,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final options = <Map<String, dynamic>>[
      {'label': 'إيقاف', 'minutes': null},
      {'label': '15 د', 'minutes': 15},
      {'label': '30 د', 'minutes': 30},
      {'label': '45 د', 'minutes': 45},
      {'label': '60 د', 'minutes': 60},
    ];

    return Row(
      children: options.map((opt) {
        final minutes = opt['minutes'] as int?;
        final label = opt['label'] as String;
        final isSelected = selectedMinutes == minutes;

        return Expanded(
          child: GestureDetector(
            onTap: () => onSelected(minutes),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              padding: EdgeInsets.symmetric(vertical: 8.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? colors.accentGold.withValues(alpha: 0.16) : colors.surfaceElevated,
                borderRadius: AppSpacing.radiusSm,
                border: Border.all(
                  color: isSelected ? colors.accentGold : colors.borderHairline,
                  width: 1.r,
                ),
              ),
              child: Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? colors.accentGold : colors.textSecondary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SpeedOptions extends StatelessWidget {
  final double selectedSpeed;
  final ValueChanged<double> onSelected;

  const _SpeedOptions({
    required this.selectedSpeed,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final speeds = [0.75, 1.0, 1.25, 1.5, 2.0];

    return Row(
      children: speeds.map((speed) {
        final isSelected = selectedSpeed == speed;

        return Expanded(
          child: GestureDetector(
            onTap: () => onSelected(speed),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              padding: EdgeInsets.symmetric(vertical: 8.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? colors.accentGold.withValues(alpha: 0.16) : colors.surfaceElevated,
                borderRadius: AppSpacing.radiusSm,
                border: Border.all(
                  color: isSelected ? colors.accentGold : colors.borderHairline,
                  width: 1.r,
                ),
              ),
              child: Text(
                '${speed}x',
                style: GoogleFonts.cairo(
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? colors.accentGold : colors.textSecondary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
