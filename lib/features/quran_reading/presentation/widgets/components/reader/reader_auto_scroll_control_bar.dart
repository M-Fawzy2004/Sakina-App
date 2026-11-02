import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

/// Floating tactical pill for managing hands-free auto-scrolling speed & pause state.
class ReaderAutoScrollControlBar extends StatelessWidget {
  final bool isPaused;
  final Color accentColor;
  final Color? cardColor;
  final Color? textColor;
  final double speed;
  final VoidCallback onTogglePause;
  final ValueChanged<double> onSpeedChanged;
  final VoidCallback onClose;

  const ReaderAutoScrollControlBar({
    super.key,
    required this.isPaused,
    required this.accentColor,
    this.cardColor,
    this.textColor,
    required this.speed,
    required this.onTogglePause,
    required this.onSpeedChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: (cardColor ?? AppColors.carbonSlate).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.6),
          width: 1.r,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onTogglePause,
            icon: Icon(
              isPaused ? Iconsax.play : Iconsax.pause,
              color: accentColor,
              size: 18.r,
            ),
          ),
          Text(
            isPaused ? 'مُتَوَقِّفٌ' : 'تَمْرِيرٌ تِلْقَائِيٌّ',
            style: AppTextStyles.caption.copyWith(
              color: textColor ?? AppColors.pureChalk,
              fontWeight: FontWeight.w700,
              fontSize: 11.sp,
            ),
          ),
          SizedBox(width: 8.w),
          _SpeedPill(
            label: '1x',
            isActive: speed == 1.0,
            accentColor: accentColor,
            onTap: () => onSpeedChanged(1.0),
          ),
          SizedBox(width: 4.w),
          _SpeedPill(
            label: '1.5x',
            isActive: speed == 1.5,
            accentColor: accentColor,
            onTap: () => onSpeedChanged(1.5),
          ),
          SizedBox(width: 4.w),
          _SpeedPill(
            label: '2x',
            isActive: speed == 2.0,
            accentColor: accentColor,
            onTap: () => onSpeedChanged(2.0),
          ),
          SizedBox(width: 8.w),
          IconButton(
            onPressed: onClose,
            icon: Icon(
              Iconsax.close_circle,
              color: AppColors.mutedSilver,
              size: 16.r,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeedPill extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color accentColor;
  final VoidCallback onTap;

  const _SpeedPill({
    required this.label,
    required this.isActive,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: isActive
              ? accentColor.withValues(alpha: 0.25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: isActive
              ? Border.all(color: accentColor, width: 0.8.r)
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isActive ? accentColor : AppColors.mutedSilver,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
            fontSize: 10.sp,
          ),
        ),
      ),
    );
  }
}

