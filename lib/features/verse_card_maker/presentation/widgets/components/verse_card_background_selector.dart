import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Comprehensive background selector supporting 10 preset celestial luxury images,
/// user custom gallery photo upload, and user custom gallery video upload (capped at 30s).
class VerseCardBackgroundSelector extends StatelessWidget {
  final String? selectedPresetAsset;
  final bool hasCustomImage;
  final bool hasCustomVideo;
  final ValueChanged<String> onSelectPreset;
  final VoidCallback onPickCustomImage;
  final VoidCallback onPickCustomVideo;

  static const List<String> presetAssets = [
    'assets/images/background_1.jpg',
    'assets/images/background_2.jpg',
    'assets/images/background_3.jpg',
    'assets/images/background_4.jpg',
    'assets/images/background_5.jpg',
    'assets/images/background_6.jpg',
    'assets/images/background_7.jpg',
    'assets/images/background_8.jpg',
    'assets/images/background_9.jpg',
    'assets/images/background_10.jpg',
  ];

  const VerseCardBackgroundSelector({
    super.key,
    required this.selectedPresetAsset,
    required this.hasCustomImage,
    required this.hasCustomVideo,
    required this.onSelectPreset,
    required this.onPickCustomImage,
    required this.onPickCustomVideo,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Iconsax.gallery,
                      size: 14.r,
                      color: colors.accentGold,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        'الخلفية والمشهد (فيديو حتى 30 ثانية أو صورة):',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (hasCustomImage || hasCustomVideo) ...[
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.5.h),
                  decoration: BoxDecoration(
                    color: colors.accentGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    hasCustomVideo ? 'فيديو ريلز (30ث)' : 'صورة مخصصة',
                    style: GoogleFonts.cairo(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.accentGold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 64.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: presetAssets.length + 2,
            separatorBuilder: (context, index) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              // Item 0: Pick Custom Image
              if (index == 0) {
                return _ActionButtonThumbnail(
                  icon: Iconsax.image,
                  label: 'صورتك',
                  isSelected: hasCustomImage,
                  onTap: () {
                    HapticService.selectionClick();
                    onPickCustomImage();
                  },
                );
              }

              // Item 1: Pick Custom Video (capped at 30 seconds)
              if (index == 1) {
                return _ActionButtonThumbnail(
                  icon: Iconsax.video_play,
                  label: 'فيديو',
                  badgeText: 'أقصى 30ث',
                  isSelected: hasCustomVideo,
                  isEmerald: true,
                  onTap: () {
                    HapticService.selectionClick();
                    onPickCustomVideo();
                  },
                );
              }

              // Preset Backgrounds (index - 2)
              final assetIndex = index - 2;
              final assetPath = presetAssets[assetIndex];
              final isSelected = !hasCustomImage &&
                  !hasCustomVideo &&
                  (selectedPresetAsset == assetPath ||
                      (selectedPresetAsset == null && assetIndex == 0));

              return _PresetImageThumbnail(
                assetPath: assetPath,
                index: assetIndex + 1,
                isSelected: isSelected,
                onTap: () {
                  HapticService.selectionClick();
                  onSelectPreset(assetPath);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActionButtonThumbnail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badgeText;
  final bool isSelected;
  final bool isEmerald;
  final VoidCallback onTap;

  const _ActionButtonThumbnail({
    required this.icon,
    required this.label,
    this.badgeText,
    required this.isSelected,
    this.isEmerald = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final activeColor = isEmerald ? colors.accentEmerald : colors.accentGold;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 54.w,
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.18)
              : colors.surfaceElevated,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? activeColor
                : colors.borderHairline.withValues(alpha: 0.6),
            width: isSelected ? 1.5.r : 0.8.r,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16.r,
                  color: isSelected ? activeColor : colors.textSecondary,
                ),
                SizedBox(height: 2.h),
                Text(
                  label,
                  style: GoogleFonts.cairo(
                    fontSize: 9.5.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? activeColor : colors.textSecondary,
                  ),
                ),
                if (badgeText != null) ...[
                  SizedBox(height: 1.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: activeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      badgeText!,
                      style: GoogleFonts.cairo(
                        fontSize: 7.5.sp,
                        fontWeight: FontWeight.w700,
                        color: activeColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PresetImageThumbnail extends StatelessWidget {
  final String assetPath;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _PresetImageThumbnail({
    required this.assetPath,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 52.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? colors.accentGold
                : colors.borderHairline.withValues(alpha: 0.6),
            width: isSelected ? 2.r : 0.8.r,
          ),
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10.r),
              ),
            ),
            child: Text(
              '$index',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
                color: isSelected ? colors.accentGold : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
