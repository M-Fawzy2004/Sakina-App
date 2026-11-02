import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Floating luxury utility capsule for live broadcast sessions.
class LiveUtilityCapsule extends StatelessWidget {
  final int? sleepTimerMinutes;
  final bool isMakkah;
  final ValueChanged<int?> onSleepTimerChanged;
  final VoidCallback onToggleSanctuary;
  final VoidCallback onOpenSettings;

  const LiveUtilityCapsule({
    super.key,
    required this.sleepTimerMinutes,
    required this.isMakkah,
    required this.onSleepTimerChanged,
    required this.onToggleSanctuary,
    required this.onOpenSettings,
  });

  void _cycleSleepTimer() {
    HapticService.lightImpact();
    final timers = <int?>[null, 15, 30, 45, 60];
    final currentIndex = timers.indexOf(sleepTimerMinutes);
    final nextTimer = (currentIndex >= 0 && currentIndex < timers.length - 1)
        ? timers[currentIndex + 1]
        : timers.first;
    onSleepTimerChanged(nextTimer);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: colors.borderHairline,
          width: 1.r,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1. Sleep Timer Toggle Pill
          GestureDetector(
            onTap: _cycleSleepTimer,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: sleepTimerMinutes != null
                    ? colors.surfaceElevated
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: sleepTimerMinutes != null
                      ? colors.accentGold
                      : Colors.transparent,
                  width: 1.r,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.timer_1,
                    size: 16.r,
                    color: sleepTimerMinutes != null
                        ? colors.accentGold
                        : colors.textSecondary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    sleepTimerMinutes != null
                        ? '$sleepTimerMinutes د'
                        : 'مؤقت الإيقاف',
                    style: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: sleepTimerMinutes != null
                          ? colors.accentGold
                          : colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Hairline divider
          Container(
            height: 16.h,
            width: 1.w,
            color: colors.borderHairline,
          ),

          // 2. Sanctuary Switcher Pill
          GestureDetector(
            onTap: () {
              HapticService.lightImpact();
              onToggleSanctuary();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: colors.borderHairline,
                  width: 1.r,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.repeat,
                    size: 15.r,
                    color: colors.accentGold,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    isMakkah ? 'المسجد النبوي 🕌' : 'المسجد الحرام 🕋',
                    style: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Hairline divider
          Container(
            height: 16.h,
            width: 1.w,
            color: colors.borderHairline,
          ),

          // 3. Quick Settings / Info Opener
          GestureDetector(
            onTap: () {
              HapticService.lightImpact();
              onOpenSettings();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              child: Icon(
                Iconsax.setting_2,
                size: 18.r,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Floating luxury stadium capsule holding utility controls side-by-side for recorded recitations.
class FloatingUtilityCapsule extends StatelessWidget {
  final double currentSpeed;
  final int? sleepTimerMinutes;
  final bool isRepeating;
  final ValueChanged<double> onSpeedChanged;
  final ValueChanged<int?> onSleepTimerChanged;
  final VoidCallback onToggleRepeat;
  final VoidCallback onOpenSettings;

  const FloatingUtilityCapsule({
    super.key,
    required this.currentSpeed,
    required this.sleepTimerMinutes,
    required this.isRepeating,
    required this.onSpeedChanged,
    required this.onSleepTimerChanged,
    required this.onToggleRepeat,
    required this.onOpenSettings,
  });

  void _cycleSpeed() {
    HapticService.lightImpact();
    const speeds = [1.0, 1.25, 1.5, 2.0];
    final currentIndex = speeds.indexOf(currentSpeed);
    final nextSpeed = (currentIndex >= 0 && currentIndex < speeds.length - 1)
        ? speeds[currentIndex + 1]
        : speeds.first;
    onSpeedChanged(nextSpeed);
  }

  void _cycleSleepTimer() {
    HapticService.lightImpact();
    final timers = <int?>[null, 15, 30, 45, 60];
    final currentIndex = timers.indexOf(sleepTimerMinutes);
    final nextTimer = (currentIndex >= 0 && currentIndex < timers.length - 1)
        ? timers[currentIndex + 1]
        : timers.first;
    onSleepTimerChanged(nextTimer);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: colors.borderHairline,
          width: 1.r,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1. Quick Speed Toggle Pill
          GestureDetector(
            onTap: _cycleSpeed,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: currentSpeed != 1.0
                    ? colors.surfaceElevated
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: currentSpeed != 1.0
                      ? colors.accentGold
                      : Colors.transparent,
                  width: 1.r,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.speedometer,
                    size: 16.r,
                    color: currentSpeed != 1.0
                        ? colors.accentGold
                        : colors.textSecondary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${currentSpeed}x',
                    style: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: currentSpeed != 1.0
                          ? colors.accentGold
                          : colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Hairline divider
          Container(
            height: 16.h,
            width: 1.w,
            color: colors.borderHairline,
          ),

          // 2. Quick Sleep Timer Toggle Pill
          GestureDetector(
            onTap: _cycleSleepTimer,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: sleepTimerMinutes != null
                    ? colors.surfaceElevated
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: sleepTimerMinutes != null
                      ? colors.accentGold
                      : Colors.transparent,
                  width: 1.r,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.timer_1,
                    size: 16.r,
                    color: sleepTimerMinutes != null
                        ? colors.accentGold
                        : colors.textSecondary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    sleepTimerMinutes != null
                        ? '$sleepTimerMinutes د'
                        : 'المؤقت',
                    style: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: sleepTimerMinutes != null
                          ? colors.accentGold
                          : colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Hairline divider
          Container(
            height: 16.h,
            width: 1.w,
            color: colors.borderHairline,
          ),

          // 3. Quick Repeat Mode Toggle
          GestureDetector(
            onTap: () {
              HapticService.lightImpact();
              onToggleRepeat();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color:
                    isRepeating ? colors.surfaceElevated : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isRepeating ? colors.accentGold : Colors.transparent,
                  width: 1.r,
                ),
              ),
              child: Icon(
                Iconsax.repeate_one,
                size: 18.r,
                color: isRepeating ? colors.accentGold : colors.textSecondary,
              ),
            ),
          ),

          // Hairline divider
          Container(
            height: 16.h,
            width: 1.w,
            color: colors.borderHairline,
          ),

          // 4. Quick Full Settings Opener
          GestureDetector(
            onTap: () {
              HapticService.lightImpact();
              onOpenSettings();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              child: Icon(
                Iconsax.setting_2,
                size: 18.r,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
