import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_cubit.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_state.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_covenant_renewal_sheet.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_daily_hope_sheet.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_emergency_haven_card.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_emergency_rescue_sheet.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_good_deeds_sheet.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_portals_grid.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_quranic_hope_card.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_sanctuary_confession_sheet.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_streak_progress_card.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_top_header.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_tree_of_light_sheet.dart';

class InabaScreen extends StatelessWidget {
  const InabaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InabaCubit>()..loadInabaData(),
      child: const _InabaScreenView(),
    );
  }
}

class _InabaScreenView extends StatelessWidget {
  const _InabaScreenView();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom + 88.h;

    return BlocConsumer<InabaCubit, InabaState>(
      listenWhen: (prev, curr) => curr.toastFeedback != null,
      listener: (context, state) {
        if (state.toastFeedback != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.toastFeedback!,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: colors.cardSurface,
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
                side: BorderSide(color: colors.borderHairline),
              ),
            ),
          );
          context.read<InabaCubit>().clearToastFeedback();
        }
      },
      builder: (context, state) {
        if (state.status == InabaStatus.loading && state.overview == null) {
          return Scaffold(
            backgroundColor: colors.background,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colors.accentGold),
              ),
            ),
          );
        }

        final overview = state.overview;

        return Scaffold(
          backgroundColor: colors.background,
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. Top Brand Header
                SliverToBoxAdapter(
                  child: InabaTopHeader(
                    onInfoTap: () => _showInabaPhilosophyDialog(context),
                  ),
                ),

                // 2. Emergency Spiritual Haven Button
                SliverToBoxAdapter(
                  child: InabaEmergencyHavenCard(
                    onTap: () {
                      InabaEmergencyRescueSheet.show(
                        context,
                        onVictoryLogged: () {
                          context.read<InabaCubit>().logSpiritualVictory();
                        },
                      );
                    },
                  ),
                ),

                // 3. Sacred Quranic Hope Verse
                const SliverToBoxAdapter(child: InabaQuranicHopeCard()),

                // 4. Streak & Purity Progress Card
                if (overview != null)
                  SliverToBoxAdapter(
                    child: InabaStreakProgressCard(
                      streakDays: overview.streakDays,
                      progress: overview.streakProgress,
                      levelTitle: overview.currentSpiritualLevelTitle,
                      statusText: overview.recoveryPathStatus,
                      onTreeTap: () {
                        InabaTreeOfLightSheet.show(
                          context,
                          streakDays: overview.streakDays,
                          progress: overview.streakProgress,
                          levels: state.spiritualLevels,
                        );
                      },
                    ),
                  ),

                // 5. Inaba Portals
                SliverToBoxAdapter(
                  child: InabaPortalsGrid(
                    onGoodDeedsTap: () {
                      InabaGoodDeedsSheet.show(
                        context,
                        deeds: state.goodDeeds,
                        onToggleDeed: (id) {
                          context.read<InabaCubit>().toggleGoodDeed(id);
                        },
                        onAddDeed: (title, category) {
                          context.read<InabaCubit>().addCustomGoodDeed(
                            title,
                            category,
                          );
                        },
                      );
                    },
                    onConfessionTap: () {
                      final cubit = context.read<InabaCubit>();
                      InabaSanctuaryConfessionSheet.show(
                        context,
                        isUnlocked: state.isConfessionUnlocked,
                        reflections: state.reflections,
                        onUnlock: cubit.unlockConfessionSanctuary,
                        onLock: cubit.lockConfessionSanctuary,
                        onSaveReflection:
                            ({
                              required title,
                              required content,
                              required moodTag,
                            }) {
                              cubit.saveReflection(
                                title: title,
                                content: content,
                                moodTag: moodTag,
                              );
                            },
                        onDeleteReflection: (id) {
                          cubit.deleteReflection(id);
                        },
                      );
                    },
                    onCovenantTap: () {
                      final cubit = context.read<InabaCubit>();
                      InabaCovenantRenewalSheet.show(
                        context,
                        steps: state.repentanceSteps,
                        onToggleStep: (id) => cubit.toggleRepentanceStep(id),
                        onRenewCovenant: () => cubit.renewCovenant(),
                      );
                    },
                    onTreeTap: () {
                      if (overview != null) {
                        InabaTreeOfLightSheet.show(
                          context,
                          streakDays: overview.streakDays,
                          progress: overview.streakProgress,
                          levels: state.spiritualLevels,
                        );
                      }
                    },
                    onHopeDoseTap: () {
                      final cubit = context.read<InabaCubit>();
                      InabaDailyHopeSheet.show(
                        context,
                        activeDose: state.activeHopeDose,
                        onNextDose: () => cubit.nextHopeDose(),
                        onToggleSave: () => cubit.toggleSaveCurrentHopeDose(),
                      );
                    },
                  ),
                ),

                // Bottom Padding for floating nav bar
                SliverToBoxAdapter(child: SizedBox(height: bottomInset)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showInabaPhilosophyDialog(BuildContext context) {
    final colors = context.colors;

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: colors.cardSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.r),
            side: BorderSide(color: colors.borderHairline, width: 1.r),
          ),
          title: Text(
            'فَلْسَفَةُ الإِنَابَةِ فِي سَكِينَة',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              fontSize: 16.sp,
            ),
          ),
          content: Text(
            'الإنابة هي الرجوع إلى الله بالقلب والجوارح في كل حين. خلق الله الإنسان ليعود إليه، ولا عيب في السقوط وإنما الخسارة في اليأس من رحمة الله.\n\nقسم الإنابة رفيقك الهادئ لبناء عادات الطهارة، مجاهدة النفس، كسب الحسنات الماحية، وتجديد العهد مع أرحم الراحمين.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSecondary,
              fontSize: 13.sp,
              height: 1.6,
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accentGold,
                foregroundColor: colors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'فهمت، بارك الله فيكم',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
