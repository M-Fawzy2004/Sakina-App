import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/modals/settings_options_dialogs.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_section_card.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_tile_item.dart';

/// Storage & Cache Management section: view cached files size and clear temporary files.
class SettingsStorageSection extends StatelessWidget {
  final String cacheSizeText;
  final ValueChanged<String> onCacheCleared;

  const SettingsStorageSection({
    super.key,
    required this.cacheSizeText,
    required this.onCacheCleared,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SettingsSectionCard(
      title: 'التَّخْزِينُ وَالذَّاكِرَةُ المُؤَقَّتَةُ',
      icon: Iconsax.folder_2,
      children: [
        SettingsTileItem(
          icon: Iconsax.folder_2,
          title: 'الذَّاكِرَةُ المُؤَقَّتَةُ لِلْمُحْتَوَى',
          subtitle: '$cacheSizeText — مِلَفَّاتٌ صَوْتِيَّةٌ وَصَفَحَاتٌ مُخَزَّنَةٌ',
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: colors.borderHairline,
                width: 0.8.r,
              ),
            ),
            child: Text(
              cacheSizeText,
              style: GoogleFonts.cairo(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: colors.accentGold,
              ),
            ),
          ),
        ),
        Divider(
          color: colors.borderHairline.withValues(alpha: 0.5),
          height: 1.h,
        ),
        SettingsTileItem(
          icon: Iconsax.trash,
          title: 'مَسْحُ الذَّاكِرَةِ المُؤَقَّتَةِ (Clear Cache)',
          subtitle: 'تَحْرِيرُ المِسَاحَةِ مَعَ الحِفَاظِ الكَامِلِ عَلَى بَيَانَاتِكَ',
          onTap: () async {
            final confirmed = await SettingsOptionsDialogs.showClearCacheDialog(
              context,
              cacheSizeText,
            );
            if (confirmed == true) {
              onCacheCleared('٠.٠ م.ب');
              if (context.mounted) {
                AppTopSnackBar.showSuccess(
                  context: context,
                  message: 'تم تفريغ الذاكرة المؤقتة بنجاح وتحرير المساحة',
                );
              }
            }
          },
        ),
      ],
    );
  }
}
