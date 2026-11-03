import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/istighfar/presentation/cubit/istighfar_cubit.dart';
import 'package:sakina_app/features/istighfar/presentation/cubit/istighfar_state.dart';
import 'package:sakina_app/features/istighfar/presentation/widgets/components/animated_sibha_bead_string.dart';
import 'package:sakina_app/features/istighfar/presentation/widgets/components/istighfar_counter_gauge.dart';
import 'package:sakina_app/features/istighfar/presentation/widgets/components/istighfar_lifetime_stats_sheet.dart';
import 'package:sakina_app/features/istighfar/presentation/widgets/components/istighfar_phrase_display.dart';
import 'package:sakina_app/features/istighfar/presentation/widgets/components/istighfar_selector_chips.dart';
import 'package:sakina_app/features/istighfar/presentation/widgets/components/istighfar_target_selector.dart';

/// The Dedicated Digital Sibha & Istighfar Sanctuary Screen.
class IstighfarScreen extends StatelessWidget {
  final String? initialItemId;

  const IstighfarScreen({
    super.key,
    this.initialItemId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<IstighfarCubit>(
      create: (_) => sl<IstighfarCubit>()..loadIstighfarData(initialId: initialItemId),
      child: const _IstighfarView(),
    );
  }
}

class _IstighfarView extends StatelessWidget {
  const _IstighfarView();

  void _showStats(BuildContext context, IstighfarLoaded state) {
    HapticService.selectionClick();
    IstighfarLifetimeStatsSheet.show(
      context,
      items: state.items,
      totalLifetimeCount: state.totalLifetimeCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final topPadding = MediaQuery.paddingOf(context).top;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          top: false,
          child: BlocBuilder<IstighfarCubit, IstighfarState>(
            builder: (context, state) {
              if (state is IstighfarLoading || state is IstighfarInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is IstighfarError) {
                return Center(
                  child: Text(
                    state.message,
                    style: GoogleFonts.almarai(color: colors.textSecondary),
                  ),
                );
              }

              if (state is IstighfarLoaded) {
                final cubit = context.read<IstighfarCubit>();
                final selected = state.selectedItem;

                return Column(
                  children: [
                    // 1. Sleek Pinned Header
                    Padding(
                      padding: EdgeInsets.only(
                        top: topPadding + 6.h,
                        left: 16.w,
                        right: 16.w,
                        bottom: 8.h,
                      ),
                      child: _IstighfarHeader(
                        totalLifetimeCount: state.totalLifetimeCount,
                        isHapticEnabled: state.isHapticEnabled,
                        onBackTap: () => Navigator.of(context).pop(),
                        onStatsTap: () => _showStats(context, state),
                        onHapticToggle: cubit.toggleHaptic,
                      ),
                    ),

                    // 2. Horizontal Phrase Selector Chips
                    IstighfarSelectorChips(
                      items: state.items,
                      selectedItemId: state.selectedItemId,
                      onItemSelected: cubit.selectItem,
                    ),

                    // 3. Main Center Counting Zone (Expanded to fill full screen height)
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: cubit.incrementCurrentCount,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: IntrinsicHeight(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 10.h,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // Sacred Phrase & Virtue
                                        IstighfarPhraseDisplay(item: selected),

                                        // Interactive Animated Sibha Bead Loop
                                        AnimatedSibhaBeadString(
                                          count: selected.currentCycleCount,
                                          onTap: cubit.incrementCurrentCount,
                                        ),

                                        // Central Tactile Counter Disc
                                        IstighfarCounterGauge(
                                          item: selected,
                                          onCountTap:
                                              cubit.incrementCurrentCount,
                                          onResetTap: cubit.resetCurrentCycle,
                                        ),

                                        // Target Selector (33, 100, 1000, مفتوح)
                                        IstighfarTargetSelector(
                                          currentTarget: selected.targetCount,
                                          onTargetSelected: cubit.setTarget,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _IstighfarHeader extends StatelessWidget {
  final int totalLifetimeCount;
  final bool isHapticEnabled;
  final VoidCallback onBackTap;
  final VoidCallback onStatsTap;
  final VoidCallback onHapticToggle;

  const _IstighfarHeader({
    required this.totalLifetimeCount,
    required this.isHapticEnabled,
    required this.onBackTap,
    required this.onStatsTap,
    required this.onHapticToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Circular Frosted Back Button (Quran Reader Design Pattern)
        _FrostedCircleButton(
          icon: Iconsax.arrow_right_3,
          accentColor: colors.accentGold,
          onTap: onBackTap,
          tooltip: 'رجوع',
        ),

        // Title
        Text(
          'مَسْبَحَةُ الاسْتِغْفَارِ',
          style: GoogleFonts.almarai(
            color: colors.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
          ),
        ),

        // Actions: Stats & Haptic in matching frosted circles
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FrostedCircleButton(
              icon: isHapticEnabled
                  ? Iconsax.mobile
                  : Iconsax.mobile_programming,
              accentColor:
                  isHapticEnabled ? colors.accentGold : colors.textSecondary,
              onTap: onHapticToggle,
              tooltip: 'الاهتزاز التفاعلي',
            ),
            SizedBox(width: 8.w),
            _FrostedCircleButton(
              icon: Iconsax.chart_2,
              accentColor: colors.accentGold,
              onTap: onStatsTap,
              tooltip: 'سجل الاستغفار',
            ),
          ],
        ),
      ],
    );
  }
}

/// Circular frosted button matching the Quran Reader top bar styling.
class _FrostedCircleButton extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;
  final String? tooltip;

  const _FrostedCircleButton({
    required this.icon,
    required this.accentColor,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.selectionClick();
          onTap();
        },
        customBorder: const CircleBorder(),
        child: Container(
          width: 42.r,
          height: 42.r,
          decoration: BoxDecoration(
            color: colors.cardSurface.withValues(alpha: 0.85),
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.accentGold.withValues(alpha: 0.45),
              width: 1.r,
            ),
          ),
          child: Center(
            child: Icon(icon, color: accentColor, size: 18.r),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}

