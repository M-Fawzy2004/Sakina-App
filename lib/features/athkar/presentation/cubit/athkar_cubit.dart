import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/athkar/domain/usecases/get_athkar_by_category_usecase.dart';
import 'package:sakina_app/features/athkar/domain/usecases/get_athkar_categories_usecase.dart';
import 'package:sakina_app/features/athkar/presentation/cubit/athkar_state.dart';

/// Cubit managing Athkar categories, items, and interactive tactile tasbih repetition.
class AthkarCubit extends Cubit<AthkarState> {
  final GetAthkarCategoriesUseCase getCategoriesUseCase;
  final GetAthkarByCategoryUseCase getAthkarByCategoryUseCase;

  AthkarCubit({
    required this.getCategoriesUseCase,
    required this.getAthkarByCategoryUseCase,
  }) : super(const AthkarInitial());

  /// Loads categories and the initial active category items.
  Future<void> loadAthkar({String? initialCategory}) async {
    emit(const AthkarLoading());

    final categoriesResult = await getCategoriesUseCase(const NoParams());

    await categoriesResult.fold(
      (failure) async {
        emit(AthkarError(message: failure.message));
      },
      (categories) async {
        if (categories.isEmpty) {
          emit(const AthkarError(message: 'لا توجد أذكار متاحة حالياً'));
          return;
        }

        final selected = (initialCategory != null &&
                categories.any((c) => c.name == initialCategory))
            ? initialCategory
            : categories.first.name;

        final itemsResult = await getAthkarByCategoryUseCase(
          GetAthkarByCategoryParams(category: selected),
        );

        itemsResult.fold(
          (failure) => emit(AthkarError(message: failure.message)),
          (items) {
            emit(AthkarLoaded(
              categories: categories,
              selectedCategory: selected,
              activeAthkar: items,
              progressMap: const {},
            ));
          },
        );
      },
    );
  }

  /// Switches active category and loads its items with zero-latency cached dispatch.
  Future<void> selectCategory(String category) async {
    final currentState = state;
    if (currentState is! AthkarLoaded) return;
    if (currentState.selectedCategory == category) return;

    final itemsResult = await getAthkarByCategoryUseCase(
      GetAthkarByCategoryParams(category: category),
    );

    itemsResult.fold(
      (failure) => emit(AthkarError(message: failure.message)),
      (items) {
        emit(currentState.copyWith(
          selectedCategory: category,
          activeAthkar: items,
          progressMap: const {},
        ));
      },
    );
  }

  /// Increments repetition count for a specific Thikr item with haptic feedback.
  void tapThikr(int index) {
    final currentState = state;
    if (currentState is! AthkarLoaded) return;
    if (index < 0 || index >= currentState.activeAthkar.length) return;

    final item = currentState.activeAthkar[index];
    final current = currentState.progressMap[index] ?? 0;

    if (current < item.count) {
      final updated = current + 1;
      final newMap = Map<int, int>.from(currentState.progressMap);
      newMap[index] = updated;

      if (updated >= item.count) {
        HapticService.success();
      } else {
        HapticService.selectionClick();
      }

      emit(currentState.copyWith(progressMap: newMap));
    }
  }

  /// Resets a specific Thikr count.
  void resetThikr(int index) {
    final currentState = state;
    if (currentState is! AthkarLoaded) return;

    final newMap = Map<int, int>.from(currentState.progressMap);
    newMap.remove(index);
    HapticService.selectionClick();
    emit(currentState.copyWith(progressMap: newMap));
  }

  /// Resets all progress counts in the current category.
  void resetCategory() {
    final currentState = state;
    if (currentState is! AthkarLoaded) return;

    HapticService.selectionClick();
    emit(currentState.copyWith(progressMap: const {}));
  }
}

