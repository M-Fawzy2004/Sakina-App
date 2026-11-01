import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/settings/domain/entities/app_accent_color.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_state.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_section_card.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_tile_item.dart';
import 'package:sakina_app/features/settings/presentation/widgets/theme_selector_screen.dart';

/// Redesigned Al-I'dadat (Settings & Preferences) Sanctuary Screen.
/// Elevated spiritual UI with a dedicated Theme & Accent Customization gateway,
/// comprehensive reading and audio preferences, and one-tap reset to defaults.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _morningEveningAzkar = true;
  bool _dailyQuranReminder = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final cubit = context.read<SettingsCubit>();
            final currentAccent =
                AppAccentColor.fromColor(state.primaryAccentColor);

            return Directionality(
              textDirection: TextDirection.rtl,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // 1. Top Sacred Brand Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Brand Crescent & Title
                          Row(
                            children: [
                              Text('🌙', style: TextStyle(fontSize: 18.sp)),
                              SizedBox(width: 8.w),
                              Text(
                                'سَكِينَةُ',
                                style: GoogleFonts.cairo(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w800,
                                  color: colors.accentGold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),

                          // Header Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: colors.cardSurface,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: colors.borderHairline,
                                width: 1.r,
                              ),
                            ),
                            child: Text(
                              'الإِعْدَادَاتُ العَامَّةُ',
                              style: GoogleFonts.cairo(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 12.h)),

                  // 2. High-Impact Theme & Appearance Hero Gateway
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: _AppearanceGatewayHero(
                        themeTitle: state.appThemeMode.title,
                        accentTitle: currentAccent.title,
                        accentColor: state.primaryAccentColor,
                        onTap: () {
                          HapticService.selectionClick();
                          ThemeSelectorScreen.open(context);
                        },
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // 3. Quran Reading & Mushaf Preferences
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SettingsSectionCard(
                        title: 'تَفْضِيلَاتُ المَصْحَفِ وَالقِرَاءَةِ',
                        icon: Iconsax.book_1,
                        children: [
                          SettingsTileItem(
                            icon: Iconsax.textalign_justifycenter,
                            title: 'حَجْمُ خَطِّ الآيَاتِ القُرْآنِيَّةِ',
                            subtitle: 'مُتَوَسِّط (26sp) — مُرِيحٌ لِلْعَيْنِ',
                            onTap: () {
                              HapticService.selectionClick();
                              AppTopSnackBar.show(
                                context: context,
                                message:
                                    'يمكنك تغيير حجم الخط مباشرة من شريط أدوات القارئ',
                              );
                            },
                          ),
                          Divider(
                            color: colors.borderHairline.withValues(alpha: 0.5),
                            height: 1.h,
                          ),
                          SettingsTileItem(
                            icon: Iconsax.document_text,
                            title: 'نَمَطُ العَرْضِ وَالتَّقْلِيبِ',
                            subtitle:
                                'كُرُوتٌ مُتَّصِلَةٌ مَعَ فِيزْيَاءِ التَّقْلِيبِ ثُلَاثِيَّةِ الأَبْعَادِ',
                            onTap: () {
                              HapticService.selectionClick();
                            },
                          ),
                          Divider(
                            color: colors.borderHairline.withValues(alpha: 0.5),
                            height: 1.h,
                          ),
                          SettingsTileItem(
                            icon: Iconsax.scroll,
                            title: 'الرَّسْمُ العُثْمَانِيُّ المَصْحَفِيُّ',
                            subtitle: 'حَفْصٌ عَنْ عَاصِمٍ (مُصْحَفُ المَدِينَةِ المُنَوَّرَةِ)',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // 4. Audio Recitations Preferences
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SettingsSectionCard(
                        title: 'الصَّوْتِيَّاتُ وَالتِّلَاوَةُ',
                        icon: Iconsax.music,
                        children: [
                          SettingsTileItem(
                            icon: Iconsax.user_tag,
                            title: 'القَارِئُ الاِفْتِرَاضِيُّ لِلتِّلَاوَةِ',
                            subtitle: 'الشَّيْخُ مِشَارِي رَاشِد العَفَاسِي (مُجَوَّدٌ)',
                            onTap: () {
                              HapticService.selectionClick();
                            },
                          ),
                          Divider(
                            color: colors.borderHairline.withValues(alpha: 0.5),
                            height: 1.h,
                          ),
                          SettingsTileItem(
                            icon: Iconsax.forward_10_seconds,
                            title: 'سُرْعَةُ التَّشْغِيلِ الاِفْتِرَاضِيَّةُ',
                            subtitle: '1.0x (طَبِيعِيٌّ)',
                            onTap: () {},
                          ),
                          Divider(
                            color: colors.borderHairline.withValues(alpha: 0.5),
                            height: 1.h,
                          ),
                          SettingsTileItem(
                            icon: Iconsax.timer_1,
                            title: 'مُؤَقِّتُ النَّوْمِ التِّلْقَائِيُّ',
                            subtitle: 'مُعَطَّلٌ حَالِيًّا',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // 5. Daily Dhikr & Reminders Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SettingsSectionCard(
                        title: 'التَّذْكِيرَاتُ وَالوِرْدُ اليَوْمِيُّ',
                        icon: Iconsax.notification,
                        children: [
                          _SettingsSwitchTile(
                            icon: Iconsax.sun_1,
                            title: 'تَنْبِيهَاتُ أَذْكَارِ الصَّبَاحِ وَالمَسَاءِ',
                            subtitle: 'تَذْكِيرٌ يَوْمِيٌّ مُنْتَظَمٌ لِحِفْظِ الأَوْقَاتِ',
                            value: _morningEveningAzkar,
                            onChanged: (val) {
                              HapticService.selectionClick();
                              setState(() => _morningEveningAzkar = val);
                            },
                          ),
                          Divider(
                            color: colors.borderHairline.withValues(alpha: 0.5),
                            height: 1.h,
                          ),
                          _SettingsSwitchTile(
                            icon: Iconsax.calendar_tick,
                            title: 'تَنْبِيهُ الوِرْدِ القُرْآنِيِّ اليَوْمِيِّ',
                            subtitle: 'مُتَابَعَةُ القِرَاءَةِ وَتَحْقِيقُ خَتْمَةِ سَكِينَةَ',
                            value: _dailyQuranReminder,
                            onChanged: (val) {
                              HapticService.selectionClick();
                              setState(() => _dailyQuranReminder = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // 6. Reset to Default Section (Requested by User)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: _SettingsResetCard(
                        onResetTap: () => _confirmResetAll(cubit),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // 7. About Application Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SettingsSectionCard(
                        title: 'عَنْ سَكِينَةَ',
                        icon: Iconsax.info_circle,
                        children: [
                          SettingsTileItem(
                            icon: Iconsax.verify,
                            title: 'إِصْدَارُ التَّطْبِيقِ',
                            subtitle: 'الإِصْدَارُ 1.0.0 — سَكِينَةٌ مَلَكِيَّةٌ',
                            trailing: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: colors.accentGold.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: colors.accentGold.withValues(alpha: 0.3),
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
                          ),
                          Divider(
                            color: colors.borderHairline.withValues(alpha: 0.5),
                            height: 1.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            child: Text(
                              'تطبيق سكينة هو صدقة جارية خالصة لوجه الله تعالى عن جميع المسلمين والمسلمات.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cairo(
                                fontSize: 11.5.sp,
                                color: colors.textSecondary.withValues(alpha: 0.8),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom spacing for floating navigation bar
                  SliverToBoxAdapter(
                    child: SizedBox(height: bottomPadding + 96.h),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmResetAll(SettingsCubit cubit) async {
    final colors = context.colors;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: colors.cardSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
            side: BorderSide(color: colors.borderHairline),
          ),
          title: Row(
            children: [
              Icon(Iconsax.rotate_left, color: colors.accentGold, size: 22.r),
              SizedBox(width: 8.w),
              Text(
                'استعادة الإعدادات الافتراضية',
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          content: Text(
            'هل تود إعادة تعيين الثيم، لون التمييز الأساسي، وكافة الإعدادات إلى الضبط الأولي للمصنع؟',
            style: GoogleFonts.cairo(
              fontSize: 13.sp,
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                'إلغاء',
                style: GoogleFonts.cairo(
                  color: colors.textSecondary,
                  fontSize: 13.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accentGold,
                foregroundColor: colors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                'استعادة الآن',
                style: GoogleFonts.cairo(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      HapticService.selectionClick();
      await cubit.resetToDefaults();
      if (!mounted) return;
      setState(() {
        _morningEveningAzkar = true;
        _dailyQuranReminder = true;
      });
      AppTopSnackBar.show(
        context: context,
        message: 'تمت استعادة الإعدادات الافتراضية بنجاح',
        icon: Iconsax.tick_circle,
      );
    }
  }
}

/// High-Impact Featured Hero Card Gateway to Dedicated Themes Screen.
class _AppearanceGatewayHero extends StatelessWidget {
  final String themeTitle;
  final String accentTitle;
  final Color accentColor;
  final VoidCallback onTap;

  const _AppearanceGatewayHero({
    required this.themeTitle,
    required this.accentTitle,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: colors.cardSurface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: colors.accentGold.withValues(alpha: 0.4),
              width: 1.2.r,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.accentGold.withValues(alpha: 0.08),
                blurRadius: 16.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Leading Icon Container
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: colors.accentGold.withValues(alpha: 0.5),
                    width: 1.r,
                  ),
                ),
                child: Icon(
                  Iconsax.colorfilter,
                  color: colors.accentGold,
                  size: 24.r,
                ),
              ),

              SizedBox(width: 14.w),

              // Title and Active Theme Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المَظْهَرُ وَالثِّيمَاتُ وَالأَلْوَانُ',
                      style: GoogleFonts.cairo(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Container(
                          width: 12.r,
                          height: 12.r,
                          decoration: BoxDecoration(
                            color: accentColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            '$themeTitle • $accentTitle',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cairo(
                              fontSize: 12.sp,
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Trailing Action Pill
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colors.borderHairline,
                    width: 0.8.r,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'تَخْصِيص',
                      style: GoogleFonts.cairo(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.accentGold,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Iconsax.arrow_left_2,
                      size: 14.r,
                      color: colors.accentGold,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dedicated Prominent Reset to Defaults Card.
class _SettingsResetCard extends StatelessWidget {
  final VoidCallback onResetTap;

  const _SettingsResetCard({required this.onResetTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.selectionClick();
          onResetTap();
        },
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: colors.cardSurface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: colors.borderHairline.withValues(alpha: 0.65),
              width: 1.r,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colors.borderHairline,
                    width: 0.8.r,
                  ),
                ),
                child: Icon(
                  Iconsax.rotate_left,
                  color: colors.accentGold,
                  size: 20.r,
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اسْتِعَادَةُ الإِعْدَادَاتِ الاِفْتِرَاضِيَّةِ',
                      style: GoogleFonts.cairo(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'إرجاع الثيم ولون التمييز وكافة التفضيلات إلى الضبط الأولي',
                      style: GoogleFonts.cairo(
                        fontSize: 11.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: colors.borderHairline,
                    width: 0.8.r,
                  ),
                ),
                child: Text(
                  'اسْتِعَادَة',
                  style: GoogleFonts.cairo(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.accentGold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Switch tile item for settings toggles.
class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: colors.borderHairline.withValues(alpha: 0.5),
                width: 0.8.r,
              ),
            ),
            child: Icon(icon, color: colors.accentGold, size: 18.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  subtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: colors.accentGold,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
