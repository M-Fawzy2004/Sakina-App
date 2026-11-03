import 'package:equatable/equatable.dart';
import 'package:sakina_app/features/istighfar/domain/entities/istighfar_item.dart';

sealed class IstighfarState extends Equatable {
  const IstighfarState();

  @override
  List<Object?> get props => [];
}

class IstighfarInitial extends IstighfarState {
  const IstighfarInitial();
}

class IstighfarLoading extends IstighfarState {
  const IstighfarLoading();
}

class IstighfarLoaded extends IstighfarState {
  final List<IstighfarItem> items;
  final String selectedItemId;
  final int totalLifetimeCount;
  final bool isHapticEnabled;
  final bool isSoundEnabled;

  const IstighfarLoaded({
    required this.items,
    required this.selectedItemId,
    required this.totalLifetimeCount,
    this.isHapticEnabled = true,
    this.isSoundEnabled = true,
  });

  IstighfarItem get selectedItem {
    for (final item in items) {
      if (item.id == selectedItemId) {
        return item;
      }
    }
    if (items.isNotEmpty) {
      return items.first;
    }
    return const IstighfarItem(
      id: 'fallback',
      arabic: 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ',
      shortTitle: 'استغفار',
      virtue: '',
    );
  }

  double get cycleProgress {
    final item = selectedItem;
    if (item.targetCount <= 0) return 0.0;
    return (item.currentCycleCount / item.targetCount).clamp(0.0, 1.0);
  }

  IstighfarLoaded copyWith({
    List<IstighfarItem>? items,
    String? selectedItemId,
    int? totalLifetimeCount,
    bool? isHapticEnabled,
    bool? isSoundEnabled,
  }) {
    return IstighfarLoaded(
      items: items ?? this.items,
      selectedItemId: selectedItemId ?? this.selectedItemId,
      totalLifetimeCount: totalLifetimeCount ?? this.totalLifetimeCount,
      isHapticEnabled: isHapticEnabled ?? this.isHapticEnabled,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
    );
  }

  @override
  List<Object?> get props => [
        items,
        selectedItemId,
        totalLifetimeCount,
        isHapticEnabled,
        isSoundEnabled,
      ];
}

class IstighfarError extends IstighfarState {
  final String message;

  const IstighfarError({required this.message});

  @override
  List<Object?> get props => [message];
}

