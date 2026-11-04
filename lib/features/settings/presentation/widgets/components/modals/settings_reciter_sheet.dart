import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';

/// Model for selectable Holy Quran Ayah reciters.
class ReciterChoice {
  final String id;
  final String name;
  final String subtitle;
  final String initials;

  const ReciterChoice({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.initials,
  });
}

/// Modal bottom sheet for choosing the default sacred Quran reciter for
/// Per-Ayah recitations in Quran Reader and Maladh Daily Verse.
class SettingsReciterSheet extends StatelessWidget {
  final String currentReciterId;
  final void Function(String reciterId, String reciterName) onReciterSelected;

  const SettingsReciterSheet({
    super.key,
    required this.currentReciterId,
    required this.onReciterSelected,
  });

  static const List<ReciterChoice> availableReciters = [
    ReciterChoice(
      id: 'Alafasy_128kbps',
      name: 'الشَّيْخُ مِشَارِي رَاشِد العَفَاسِي',
      subtitle: 'حَفْصٌ عَنْ عَاصِمٍ • تِلَاوَةٌ نَدِيَّةٌ مُرَتَّلَةٌ',
      initials: 'م',
    ),
    ReciterChoice(
      id: 'Abdul_Basit_Murattal_192kbps',
      name: 'الشَّيْخُ عَبْدُ البَاسِطِ عَبْدُ الصَّمَدِ',
      subtitle: 'حَفْصٌ عَنْ عَاصِمٍ • خُشُوعٌ وَإِتْقَانٌ تَارِيخِيٌّ',
      initials: 'ع',
    ),
    ReciterChoice(
      id: 'Husary_128kbps',
      name: 'الشَّيْخُ مَحْمُود خَلِيل الحُصَرِيُّ',
      subtitle: 'المُصْحَفُ المُرَتَّلُ المُعَلِّمُ • أَعْلَى دَرَجَاتِ التَّجْوِيدِ',
      initials: 'ح',
    ),
    ReciterChoice(
      id: 'Minshawy_Murattal_128kbps',
      name: 'الشَّيْخُ مُحَمَّد صِدِّيق المِنْشَاوِي',
      subtitle: 'تِلَاوَةٌ مُبْكِيَةٌ خَاشِعَةٌ • الصَّوْتُ البَاكِي',
      initials: 'م',
    ),
    ReciterChoice(
      id: 'Ghamadi_40kbps',
      name: 'الشَّيْخُ سَعْد الغَامِدِي',
      subtitle: 'تِلَاوَةٌ هَادِئَةٌ سَاكِنَةٌ • تَأَمُّلٌ وَطُمَأْنِينَةٌ',
      initials: 'س',
    ),
  ];

  static Future<void> show({
    required BuildContext context,
    required String currentReciterId,
    required void Function(String reciterId, String reciterName)
        onReciterSelected,
  }) {
    HapticService.selectionClick();
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SettingsReciterSheet(
        currentReciterId: currentReciterId,
        onReciterSelected: onReciterSelected,
      ),
    );
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
            // Handle
            Container(
              width: 38.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colors.accentGold.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 14.h),

            // Header Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.user_tag, size: 20.r, color: colors.accentGold),
                SizedBox(width: 8.w),
                Text(
                  'اخْتِيَارُ قَارِئِ الآيَاتِ وَالمَلَاذِ',
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Reciter Items
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: availableReciters.length,
                separatorBuilder: (_, _) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final reciter = availableReciters[index];
                  final isSelected = currentReciterId == reciter.id;

                  return InkWell(
                    onTap: () {
                      HapticService.selectionClick();
                      onReciterSelected(reciter.id, reciter.name);
                      Navigator.of(context).pop();
                    },
                    borderRadius: BorderRadius.circular(14.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.accentGold.withValues(alpha: 0.12)
                            : colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: isSelected
                              ? colors.accentGold
                              : colors.borderHairline.withValues(alpha: 0.6),
                          width: isSelected ? 1.5.r : 0.8.r,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36.r,
                            height: 36.r,
                            decoration: BoxDecoration(
                              color: colors.surfaceElevated,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? colors.accentGold
                                    : colors.borderHairline,
                                width: 1.r,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                reciter.initials,
                                style: GoogleFonts.cairo(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? colors.accentGold
                                      : colors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reciter.name,
                                  style: GoogleFonts.cairo(
                                    fontSize: 13.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                Text(
                                  reciter.subtitle,
                                  style: GoogleFonts.cairo(
                                    fontSize: 10.5.sp,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: colors.accentGold,
                              size: 20.r,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
