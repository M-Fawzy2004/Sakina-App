import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:sakina_app/features/settings/presentation/cubit/settings_state.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_section_card.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/settings_tile_item.dart';
import 'package:sakina_app/features/settings/presentation/widgets/components/theme_mode_selector_card.dart';

/// Al-I'dadat (Settings & Preferences) Screen.
/// Provides full theme switching between OLED Dark and Soothing Parchment Light Mode,
/// reading configurations, audio settings, and application metadata.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top Sacred Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left Crescent & Brand
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

                        // Section Title Badge
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
                            'الإِعْدَادَاتُ',
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

                // Theme Mode Selector Card (Core User Request)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ThemeModeSelectorCard(
                      currentMode: state.appThemeMode,
                      onModeChanged: cubit.setThemeMode,
                    ),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                // Quran Reading Preferences Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SettingsSectionCard(
                      title: 'تَفْضِيلَاتُ القِرَاءَةِ وَالتِّلَاوَةِ',
                      icon: Iconsax.book_1,
                      children: [
                        SettingsTileItem(
                          icon: Iconsax.textalign_justifycenter,
                          title: 'حَجْمُ خَطِّ الآيَاتِ',
                          subtitle: 'مُتَوَسِّط (22sp)',
                          onTap: () {},
                        ),
                        Divider(
                          color: colors.borderHairline.withValues(alpha: 0.5),
                          height: 1.h,
                        ),
                        SettingsTileItem(
                          icon: Iconsax.document_text,
                          title: 'نَمَطُ العَرْضِ',
                          subtitle: 'سَرْدٌ سَطْرِيٌّ آيَةً بِآيَةٍ',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                // Audio Preferences Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SettingsSectionCard(
                      title: 'الصَّوْتِيَّاتُ وَالتَّشْغِيلُ',
                      icon: Iconsax.music,
                      children: [
                        SettingsTileItem(
                          icon: Iconsax.timer_1,
                          title: 'مُؤَقِّتُ النَّوْمِ التِّلْقَائِيُّ',
                          subtitle: 'مُعَطَّلٌ حَالِيًّا',
                          onTap: () {},
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
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                // Application Info Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SettingsSectionCard(
                      title: 'عَنِ التَّطْبِيقِ',
                      icon: Iconsax.info_circle,
                      children: [
                        SettingsTileItem(
                          icon: Iconsax.verify,
                          title: 'إِصْدَارُ سَكِينَةَ',
                          subtitle: 'الإِصْدَارُ 1.0.0 — مَلَكِيٌّ',
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
                      ],
                    ),
                  ),
                ),

                // Bottom spacing for floating navigation bar
                SliverToBoxAdapter(
                  child: SizedBox(height: bottomPadding + 96.h),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
