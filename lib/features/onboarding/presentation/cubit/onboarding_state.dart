import 'package:equatable/equatable.dart';
import 'package:sakina_app/features/onboarding/domain/entities/onboarding_item.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

final class OnboardingActive extends OnboardingState {
  final int currentIndex;
  final List<OnboardingItem> items;

  const OnboardingActive({
    required this.currentIndex,
    required this.items,
  });

  bool get isLastPage => currentIndex == items.length - 1;
  OnboardingItem get currentItem => items[currentIndex];

  @override
  List<Object?> get props => [currentIndex, items];
}

final class OnboardingCompleted extends OnboardingState {
  final String destinationRoute;

  const OnboardingCompleted({required this.destinationRoute});

  @override
  List<Object?> get props => [destinationRoute];
}

