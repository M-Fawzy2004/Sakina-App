import 'package:equatable/equatable.dart';

/// Pure immutable domain entity representing a single onboarding slide.
class OnboardingItem extends Equatable {
  final int index;
  final String title;
  final String subtitle;
  final String imageAsset;
  final String buttonText;

  const OnboardingItem({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    required this.buttonText,
  });

  @override
  List<Object?> get props => [index, title, subtitle, imageAsset, buttonText];
}

