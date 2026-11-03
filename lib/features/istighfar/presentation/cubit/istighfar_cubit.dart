import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/istighfar/data/datasources/istighfar_local_data_source.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/get_istighfar_items_usecase.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/get_istighfar_stats_usecase.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/increment_istighfar_count_usecase.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/reset_istighfar_count_usecase.dart';
import 'package:sakina_app/features/istighfar/domain/usecases/set_istighfar_target_usecase.dart';
import 'package:sakina_app/features/istighfar/presentation/cubit/istighfar_state.dart';

class IstighfarCubit extends Cubit<IstighfarState> {
  final GetIstighfarItemsUseCase getItemsUseCase;
  final IncrementIstighfarCountUseCase incrementCountUseCase;
  final ResetIstighfarCountUseCase resetCountUseCase;
  final GetIstighfarStatsUseCase getStatsUseCase;
  final SetIstighfarTargetUseCase setTargetUseCase;
  final IstighfarLocalDataSource localDataSource;

  IstighfarCubit({
    required this.getItemsUseCase,
    required this.incrementCountUseCase,
    required this.resetCountUseCase,
    required this.getStatsUseCase,
    required this.setTargetUseCase,
    required this.localDataSource,
  }) : super(const IstighfarInitial());

  Future<void> loadIstighfarData({String? initialId}) async {
    final currentState = state;
    if (currentState is IstighfarLoaded) {
      if (initialId != null && currentState.selectedItemId != initialId) {
        await selectItem(initialId);
      }
      return;
    }

    emit(const IstighfarLoading());

    final itemsResult = await getItemsUseCase(const NoParams());
    final statsResult = await getStatsUseCase(const NoParams());

    itemsResult.fold(
      (failure) => emit(IstighfarError(message: failure.message)),
      (items) {
        if (items.isEmpty) {
          emit(const IstighfarError(message: 'تعذر تحميل قائمة الاستغفار'));
          return;
        }

        final savedSelectedId = initialId;
        final selectedId = (savedSelectedId != null &&
                items.any((i) => i.id == savedSelectedId))
            ? savedSelectedId
            : items.first.id;

        final totalLifetime = statsResult.getOrElse((_) => 0);

        emit(
          IstighfarLoaded(
            items: items,
            selectedItemId: selectedId,
            totalLifetimeCount: totalLifetime,
          ),
        );
      },
    );
  }

  Future<void> selectItem(String itemId) async {
    final currentState = state;
    if (currentState is! IstighfarLoaded) return;
    if (currentState.selectedItemId == itemId) return;

    if (currentState.isHapticEnabled) {
      HapticService.selectionClick();
    }

    await localDataSource.setSelectedItemId(itemId);

    emit(currentState.copyWith(selectedItemId: itemId));
  }

  Future<void> incrementCurrentCount() async {
    final currentState = state;
    if (currentState is! IstighfarLoaded) return;

    final selected = currentState.selectedItem;

    if (currentState.isHapticEnabled) {
      // If next tap reaches or surpasses target, trigger celebratory impact
      if (selected.targetCount > 0 &&
          selected.currentCycleCount + 1 >= selected.targetCount) {
        HapticFeedback.heavyImpact();
      } else {
        HapticService.selectionClick();
      }
    }

    final result = await incrementCountUseCase(
      IncrementIstighfarCountParams(itemId: selected.id),
    );

    result.fold(
      (failure) {
        // Silent recovery on persistence blip
      },
      (updatedItem) {
        final updatedList = currentState.items.map((item) {
          return item.id == updatedItem.id ? updatedItem : item;
        }).toList();

        emit(
          currentState.copyWith(
            items: updatedList,
            totalLifetimeCount: currentState.totalLifetimeCount + 1,
          ),
        );
      },
    );
  }

  Future<void> resetCurrentCycle() async {
    final currentState = state;
    if (currentState is! IstighfarLoaded) return;

    if (currentState.isHapticEnabled) {
      HapticService.selectionClick();
    }

    final selected = currentState.selectedItem;
    final result = await resetCountUseCase(
      ResetIstighfarCountParams(itemId: selected.id),
    );

    result.fold(
      (failure) {},
      (resetItem) {
        final updatedList = currentState.items.map((item) {
          return item.id == resetItem.id ? resetItem : item;
        }).toList();

        emit(currentState.copyWith(items: updatedList));
      },
    );
  }

  Future<void> setTarget(int target) async {
    final currentState = state;
    if (currentState is! IstighfarLoaded) return;

    if (currentState.isHapticEnabled) {
      HapticService.selectionClick();
    }

    final selected = currentState.selectedItem;
    final result = await setTargetUseCase(
      SetIstighfarTargetParams(itemId: selected.id, target: target),
    );

    result.fold(
      (failure) {},
      (updatedItem) {
        final updatedList = currentState.items.map((item) {
          return item.id == updatedItem.id ? updatedItem : item;
        }).toList();

        emit(currentState.copyWith(items: updatedList));
      },
    );
  }

  void toggleHaptic() {
    final currentState = state;
    if (currentState is! IstighfarLoaded) return;
    emit(currentState.copyWith(isHapticEnabled: !currentState.isHapticEnabled));
  }

  void toggleSound() {
    final currentState = state;
    if (currentState is! IstighfarLoaded) return;
    emit(currentState.copyWith(isSoundEnabled: !currentState.isSoundEnabled));
  }
}

