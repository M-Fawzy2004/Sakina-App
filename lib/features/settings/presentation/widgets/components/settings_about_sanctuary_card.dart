import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/modals/settings_developer_contact_dialog.dart';
import 'package:share_plus/share_plus.dart';

/// Dignified About Sakina & Perpetual Charity (صدقة جارية) Card.
class SettingsAboutSanctuaryCard extends StatelessWidget {
  const SettingsAboutSanctuaryCard({super.key});

  Future<void> _shareApp(BuildContext context) async {
    HapticService.selectionClick();
    const shareMessage = 'قال رسول الله ﷺ: «الدَّالُّ عَلَى الخَيْرِ كَفَاعِلِهِ».\n\n'
        'أُهْدِيكَ تطبيق «سَكِينَة» — واحة إسلامية هادئة للمصحف الشريف والأذكار العطرة والإنابة والتطهر، '
        'وهو وقفٌ وصدقة جارية خالصة لوجه الله تعالى بدون أي إعلانات أو ربح مادي.\n'
        'حمله الآن وانشره ليعم النفع والأجر: https://sakina.app';

    try {
      final box = context.findRenderObject() as RenderBox?;
      final originRect = box != null
          ? (box.localToGlobal(Offset.zero) & box.size)
          : Rect.fromLTWH(0, 0, 100.w, 100.h);

      await SharePlus.instance.share(
        ShareParams(
          text: shareMessage,
          subject: 'تطبيق سكينة — صدقة جارية',
          sharePositionOrigin: originRect,
        ),
      );
    } catch (_) {
      if (context.mounted) {
        AppTopSnackBar.show(
          context: context,
          message: 'تم تجهيز نص مشاركة التطبيق بنجاح',
        );
      }
    }
  }

  void _showAppreciation(BuildContext context) {
    HapticService.selectionClick();
    AppTopSnackBar.showSuccess(
      context: context,
      message: 'جزاكم الله خيراً وكتب أجركم وتقبل دعاءكم بظهر الغيب',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colors.borderHairline.withValues(alpha: 0.8),
          width: 1.r,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title & Version Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32.r,
                    height: 32.r,
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.borderHairline,
                        width: 1.r,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Iconsax.info_circle,
                        size: 16.r,
                        color: colors.accentGold,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'عَنْ سَكِينَةَ',
                    style: GoogleFonts.cairo(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: colors.accentGold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: colors.accentGold.withValues(alpha: 0.35),
                    width: 0.8.r,
                  ),
                ),
                child: Text(
                  'v1.0.0',
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.accentGold,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Perpetual Charity Declaration Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: colors.accentGold.withValues(alpha: 0.25),
                width: 0.8.r,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.heart5,
                        size: 14.r, color: colors.accentGold),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        'وَقْفٌ وَصَدَقَةٌ جَارِيَةٌ لِوَجْهِ اللَّهِ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: colors.accentGold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  'تطبيق «سَكِينَة» صُنع ليكون وقفاً وصدقة جارية عن صانعه ووالديه وعن سائر المسلمين والمسلمات الأحياء منهم والأموات. التطبيق مجاني 100% وخالٍ تماماً من أي إعلانات أو غرض ربحي.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 11.5.sp,
                    color: colors.textSecondary.withValues(alpha: 0.9),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // Share Application Action Row
          _ActionRow(
            icon: Iconsax.share,
            title: 'مُشَارَكَةُ التَّطْبِيقِ كَصَدَقَةٍ جَارِيَةٍ',
            subtitle: 'انشر الخير وكن شريكاً في أجر التلاوة والذكر',
            onTap: () => _shareApp(context),
          ),

          Divider(
            color: colors.borderHairline.withValues(alpha: 0.5),
            height: 1.h,
          ),

          // Rate / Pray Action Row
          _ActionRow(
            icon: Iconsax.star_1,
            title: 'دَعْوَةٌ بِظَهْرِ الغَيْبِ لِصَانِعِ التَّطْبِيقِ',
            subtitle: 'تقبل الله منا ومنكم صالح الأعمال وجعلها في موازين الحسنات',
            onTap: () => _showAppreciation(context),
          ),

          Divider(
            color: colors.borderHairline.withValues(alpha: 0.5),
            height: 1.h,
          ),

          // Developer Contact Action Row
          _ActionRow(
            icon: Iconsax.user_tag,
            title: 'تَوَاصَلْ مَعَ مُطَوِّرِ التَّطْبِيقِ',
            subtitle: 'م. محمد فوزي • mohamedfawzydev27@gmail.com',
            onTap: () => SettingsDeveloperContactDialog.show(context),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        child: Row(
          children: [
            Icon(icon, size: 18.r, color: colors.accentGold),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.cairo(
                      fontSize: 10.5.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Iconsax.arrow_left_2,
              size: 14.r,
              color: colors.textSecondary.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
