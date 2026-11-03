import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/features/inaba_recovery/data/datasources/inaba_recovery_plans_local_data_source.dart';
import 'package:sakina_app/features/inaba_recovery/domain/services/mihrab_pin_service.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/add_custom_good_deed_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/delete_spiritual_reflection_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/get_daily_hope_doses_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/get_good_deeds_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/get_inaba_overview_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/get_repentance_steps_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/get_spiritual_levels_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/get_spiritual_reflections_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/log_spiritual_victory_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/renew_covenant_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/save_spiritual_reflection_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/toggle_good_deed_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/toggle_repentance_step_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/domain/usecases/toggle_save_hope_dose_usecase.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_state.dart';

class InabaCubit extends Cubit<InabaState> {
  final GetInabaOverviewUseCase getInabaOverviewUseCase;
  final GetGoodDeedsUseCase getGoodDeedsUseCase;
  final ToggleGoodDeedUseCase toggleGoodDeedUseCase;
  final AddCustomGoodDeedUseCase addCustomGoodDeedUseCase;
  final GetDailyHopeDosesUseCase getDailyHopeDosesUseCase;
  final ToggleSaveHopeDoseUseCase toggleSaveHopeDoseUseCase;
  final GetSpiritualLevelsUseCase getSpiritualLevelsUseCase;
  final GetSpiritualReflectionsUseCase getSpiritualReflectionsUseCase;
  final SaveSpiritualReflectionUseCase saveSpiritualReflectionUseCase;
  final DeleteSpiritualReflectionUseCase deleteSpiritualReflectionUseCase;
  final GetRepentanceStepsUseCase getRepentanceStepsUseCase;
  final ToggleRepentanceStepUseCase toggleRepentanceStepUseCase;
  final RenewCovenantUseCase renewCovenantUseCase;
  final LogSpiritualVictoryUseCase logSpiritualVictoryUseCase;
  final MihrabPinService? mihrabPinService;
  final InabaRecoveryPlansLocalDataSource? recoveryPlansLocalDataSource;

  InabaCubit({
    required this.getInabaOverviewUseCase,
    required this.getGoodDeedsUseCase,
    required this.toggleGoodDeedUseCase,
    required this.addCustomGoodDeedUseCase,
    required this.getDailyHopeDosesUseCase,
    required this.toggleSaveHopeDoseUseCase,
    required this.getSpiritualLevelsUseCase,
    required this.getSpiritualReflectionsUseCase,
    required this.saveSpiritualReflectionUseCase,
    required this.deleteSpiritualReflectionUseCase,
    required this.getRepentanceStepsUseCase,
    required this.toggleRepentanceStepUseCase,
    required this.renewCovenantUseCase,
    required this.logSpiritualVictoryUseCase,
    this.mihrabPinService,
    this.recoveryPlansLocalDataSource,
  }) : super(const InabaState());

  Future<void> loadInabaData() async {
    emit(state.copyWith(status: InabaStatus.loading));

    final overviewRes = await getInabaOverviewUseCase(const NoParams());
    final goodDeedsRes = await getGoodDeedsUseCase(const NoParams());
    final hopeDosesRes = await getDailyHopeDosesUseCase(const NoParams());
    final levelsRes = await getSpiritualLevelsUseCase(const NoParams());
    final reflectionsRes =
        await getSpiritualReflectionsUseCase(const NoParams());
    final stepsRes = await getRepentanceStepsUseCase(const NoParams());

    final plans = await recoveryPlansLocalDataSource?.getRecoveryPlans() ?? [];
    final hasPin = mihrabPinService?.hasPin() ?? false;

    overviewRes.fold(
      (failure) => emit(
        state.copyWith(
          status: InabaStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (overview) {
        emit(
          state.copyWith(
            status: InabaStatus.loaded,
            overview: overview,
            goodDeeds: goodDeedsRes.getOrElse((_) => []),
            hopeDoses: hopeDosesRes.getOrElse((_) => []),
            spiritualLevels: levelsRes.getOrElse((_) => []),
            reflections: reflectionsRes.getOrElse((_) => []),
            repentanceSteps: stepsRes.getOrElse((_) => []),
            recoveryPlans: plans,
            hasMihrabPin: hasPin,
          ),
        );
      },
    );
  }

  Future<void> toggleGoodDeed(String id) async {
    final res = await toggleGoodDeedUseCase(id);
    res.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (updatedDeed) async {
        final updatedList = state.goodDeeds.map((d) {
          return d.id == id ? updatedDeed : d;
        }).toList();

        // Refresh overview
        final overviewRes = await getInabaOverviewUseCase(const NoParams());
        final newOverview = overviewRes.getOrElse((_) => state.overview!);

        emit(
          state.copyWith(
            goodDeeds: updatedList,
            overview: newOverview,
            toastFeedback: updatedDeed.isCompletedToday
                ? 'تقبل الله عملك الصالح، وزادك إيماناً'
                : null,
          ),
        );
      },
    );
  }

  Future<void> addCustomGoodDeed(String title, String category) async {
    if (title.trim().isEmpty) return;

    final res = await addCustomGoodDeedUseCase(
      AddCustomGoodDeedParams(title: title.trim(), category: category.trim()),
    );
    res.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (newDeed) {
        final updatedList = [newDeed, ...state.goodDeeds];
        emit(
          state.copyWith(
            goodDeeds: updatedList,
            toastFeedback: 'تمت إضافة العمل الصالح لقائمتك المباركة',
          ),
        );
      },
    );
  }

  void nextHopeDose() {
    if (state.hopeDoses.isEmpty) return;
    final nextIndex = (state.currentHopeDoseIndex + 1) % state.hopeDoses.length;
    emit(state.copyWith(currentHopeDoseIndex: nextIndex));
  }

  void prevHopeDose() {
    if (state.hopeDoses.isEmpty) return;
    final prevIndex =
        (state.currentHopeDoseIndex - 1 + state.hopeDoses.length) %
            state.hopeDoses.length;
    emit(state.copyWith(currentHopeDoseIndex: prevIndex));
  }

  Future<void> toggleSaveCurrentHopeDose() async {
    final active = state.activeHopeDose;
    if (active == null) return;

    final res = await toggleSaveHopeDoseUseCase(active.id);
    res.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (updatedDose) {
        final updatedList = state.hopeDoses.map((d) {
          return d.id == active.id ? updatedDose : d;
        }).toList();

        emit(
          state.copyWith(
            hopeDoses: updatedList,
            toastFeedback: updatedDose.isSaved
                ? 'تم حفظ بطاقة الرجاء في محفوظاتك'
                : 'تمت إزالة البطاقة من المحفوظات',
          ),
        );
      },
    );
  }

  void unlockConfessionSanctuary() {
    emit(state.copyWith(isConfessionUnlocked: true));
  }

  void lockConfessionSanctuary() {
    emit(state.copyWith(isConfessionUnlocked: false));
  }

  // --- Recovery Plans Management ---
  Future<void> togglePlanStep(String planId, int dayNumber) async {
    if (recoveryPlansLocalDataSource == null) return;
    try {
      final updatedPlan = await recoveryPlansLocalDataSource!
          .togglePlanDayStep(planId: planId, dayNumber: dayNumber);
      final updatedPlans = state.recoveryPlans
          .map((p) => p.id == planId ? updatedPlan : p)
          .toList();
      final step =
          updatedPlan.steps.firstWhere((s) => s.dayNumber == dayNumber);
      emit(
        state.copyWith(
          recoveryPlans: updatedPlans,
          toastFeedback: step.isCompleted
              ? 'تم إنجاز خطوة اليوم بنجاح، ثبّتك الله'
              : 'تم تعديل حالة الخطوة',
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> resetPlan(String planId) async {
    if (recoveryPlansLocalDataSource == null) return;
    try {
      await recoveryPlansLocalDataSource!.resetPlan(planId);
      final plans = await recoveryPlansLocalDataSource!.getRecoveryPlans();
      emit(
        state.copyWith(
          recoveryPlans: plans,
          toastFeedback: 'تمت إعادة ضبط الخطة لبدء مسار جديد',
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  // --- Mihrab PIN Security Management ---
  bool verifyMihrabPin(String pin) {
    if (mihrabPinService == null) {
      unlockConfessionSanctuary();
      return true;
    }
    final isValid = mihrabPinService!.verifyPin(pin);
    if (isValid) {
      unlockConfessionSanctuary();
    }
    return isValid;
  }

  Future<bool> setMihrabPin(String pin) async {
    if (mihrabPinService == null) {
      unlockConfessionSanctuary();
      return true;
    }
    final success = await mihrabPinService!.setPin(pin);
    if (success) {
      emit(
        state.copyWith(
          hasMihrabPin: true,
          isConfessionUnlocked: true,
          toastFeedback: 'تم تفعيل رمز القفل لمحرابك بنجاح',
        ),
      );
    }
    return success;
  }

  Future<bool> removeMihrabPin() async {
    if (mihrabPinService == null) return true;
    final success = await mihrabPinService!.removePin();
    if (success) {
      emit(
        state.copyWith(
          hasMihrabPin: false,
          toastFeedback: 'تمت إزالة رمز قفل المحراب',
        ),
      );
    }
    return success;
  }

  Future<void> saveReflection({
    required String title,
    required String content,
    required String moodTag,
  }) async {
    if (content.trim().isEmpty) return;

    final res = await saveSpiritualReflectionUseCase(
      SaveSpiritualReflectionParams(
        title: title,
        content: content,
        moodTag: moodTag,
      ),
    );
    res.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (newReflection) async {
        final updatedList = [newReflection, ...state.reflections];
        final overviewRes = await getInabaOverviewUseCase(const NoParams());
        final newOverview = overviewRes.getOrElse((_) => state.overview!);

        emit(
          state.copyWith(
            reflections: updatedList,
            overview: newOverview,
            toastFeedback: 'حُفظت مناجاتك بأمان في محرابك الخاص',
          ),
        );
      },
    );
  }

  Future<void> deleteReflection(String id) async {
    final res = await deleteSpiritualReflectionUseCase(id);
    res.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) async {
        final updatedList = state.reflections.where((r) => r.id != id).toList();
        final overviewRes = await getInabaOverviewUseCase(const NoParams());
        final newOverview = overviewRes.getOrElse((_) => state.overview!);

        emit(
          state.copyWith(
            reflections: updatedList,
            overview: newOverview,
            toastFeedback: 'تم محو الخاطرة بسلام',
          ),
        );
      },
    );
  }

  Future<void> toggleRepentanceStep(String id) async {
    final res = await toggleRepentanceStepUseCase(id);
    res.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (updatedStep) {
        final updatedList = state.repentanceSteps.map((s) {
          return s.id == id ? updatedStep : s;
        }).toList();

        emit(state.copyWith(repentanceSteps: updatedList));
      },
    );
  }

  Future<void> renewCovenant() async {
    emit(state.copyWith(status: InabaStatus.loading));
    final res = await renewCovenantUseCase(const NoParams());
    res.fold(
      (failure) => emit(
        state.copyWith(
          status: InabaStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (newOverview) async {
        final stepsRes = await getRepentanceStepsUseCase(const NoParams());
        final levelsRes = await getSpiritualLevelsUseCase(const NoParams());

        emit(
          state.copyWith(
            status: InabaStatus.loaded,
            overview: newOverview,
            repentanceSteps: stepsRes.getOrElse((_) => []),
            spiritualLevels: levelsRes.getOrElse((_) => []),
            toastFeedback:
                'مبارك عهدك الجديد مع الله.. { إِنَّ اللَّهَ يُحِبُّ التَّوَّابِينَ }',
          ),
        );
      },
    );
  }

  Future<void> logSpiritualVictory() async {
    final res = await logSpiritualVictoryUseCase(const NoParams());
    res.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (newOverview) async {
        final levelsRes = await getSpiritualLevelsUseCase(const NoParams());

        emit(
          state.copyWith(
            overview: newOverview,
            spiritualLevels: levelsRes.getOrElse((_) => []),
            toastFeedback: 'الحمد لله الذي بنعمته تتم الصالحات.. نصر وثبات!',
          ),
        );
      },
    );
  }

  void clearToastFeedback() {
    emit(state.copyWith(toastFeedback: null));
  }
}
