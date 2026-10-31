import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

/// Reader preferences bottom sheet for scaling text size.
class QuranReaderSettingsSheet extends StatelessWidget {
  final double fontSizeDelta;
  final ValueChanged<double> onFontSizeChanged;

  const QuranReaderSettingsSheet({
    super.key,
    required this.fontSizeDelta,
    required this.onFontSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: AppColors.carbonSlate,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(
          color: AppColors.goldBorderStroke,
          width: 1.2.r,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.champagneGold.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'إِعْدَادَاتُ القِرَاءَةِ',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.champagneGold,
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'حَجْمُ الخَطِّ القُرْآنِيِّ',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.pureChalk,
                  fontSize: 13.5.sp,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: fontSizeDelta > -4.0
                        ? () => onFontSizeChanged(fontSizeDelta - 2.0)
                        : null,
                    icon: Icon(
                      Icons.remove_circle_outline_rounded,
                      color: AppColors.champagneGold,
                      size: 24.r,
                    ),
                  ),
                  Text(
                    '${(21 + fontSizeDelta).toInt()}',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.champagneGold,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    onPressed: fontSizeDelta < 8.0
                        ? () => onFontSizeChanged(fontSizeDelta + 2.0)
                        : null,
                    icon: Icon(
                      Icons.add_circle_outline_rounded,
                      color: AppColors.champagneGold,
                      size: 24.r,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}

