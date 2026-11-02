import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';

class SettingsSectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const SettingsSectionTitle({
    super.key,
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

class SleepTimerOptions extends StatelessWidget {
  final int? selectedMinutes;
  final ValueChanged<int?> onSelected;

  const SleepTimerOptions({
    super.key,
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
                color: isSelected
                    ? colors.accentGold.withValues(alpha: 0.16)
                    : colors.surfaceElevated,
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

class SpeedOptions extends StatelessWidget {
  final double selectedSpeed;
  final ValueChanged<double> onSelected;

  const SpeedOptions({
    super.key,
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
                color: isSelected
                    ? colors.accentGold.withValues(alpha: 0.16)
                    : colors.surfaceElevated,
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

class LiveBroadcastInfoBox extends StatelessWidget {
  const LiveBroadcastInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: AppSpacing.radiusMd,
        border: Border.all(
          color: colors.borderHairline,
          width: 1.r,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Iconsax.wifi,
                color: colors.accentEmerald,
                size: 18.r,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'البث الرسمي المباشر من شبكة MP3Quran',
                  style: GoogleFonts.cairo(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Iconsax.music_dashboard,
                color: colors.accentGold,
                size: 18.r,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'جودة الصوت: استريو فائق النقاء 320kbps HLS',
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

