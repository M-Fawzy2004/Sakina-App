import 'package:equatable/equatable.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_category_entity.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_item_entity.dart';

sealed class AthkarState extends Equatable {
  const AthkarState();

  @override
  List<Object?> get props => [];
}

class AthkarInitial extends AthkarState {
  const AthkarInitial();
}

class AthkarLoading extends AthkarState {
  const AthkarLoading();
}

class AthkarLoaded extends AthkarState {
  final List<AthkarCategoryEntity> categories;
  final String selectedCategory;
  final List<AthkarItemEntity> activeAthkar;
  final Map<int, int> progressMap;

  const AthkarLoaded({
    required this.categories,
    required this.selectedCategory,
    required this.activeAthkar,
    this.progressMap = const {},
  });

  int get totalCompletedCount {
    int completed = 0;
    for (int i = 0; i < activeAthkar.length; i++) {
      final current = progressMap[i] ?? 0;
      if (current >= activeAthkar[i].count) {
        completed++;
      }
    }
    return completed;
  }

  double get completionProgress {
    if (activeAthkar.isEmpty) return 0.0;
    return (totalCompletedCount / activeAthkar.length).clamp(0.0, 1.0);
  }

  AthkarLoaded copyWith({
    List<AthkarCategoryEntity>? categories,
    String? selectedCategory,
    List<AthkarItemEntity>? activeAthkar,
    Map<int, int>? progressMap,
  }) {
    return AthkarLoaded(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      activeAthkar: activeAthkar ?? this.activeAthkar,
      progressMap: progressMap ?? this.progressMap,
    );
  }

  @override
  List<Object?> get props => [
        categories,
        selectedCategory,
        activeAthkar,
        progressMap,
      ];
}

class AthkarError extends AthkarState {
  final String message;

  const AthkarError({required this.message});

  @override
  List<Object?> get props => [message];
}

