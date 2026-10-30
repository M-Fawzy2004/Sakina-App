import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakina_app/core/constants/app_assets.dart';
import 'package:sakina_app/core/usecases/usecase.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/onboarding/domain/entities/onboarding_item.dart';
import 'package:sakina_app/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:sakina_app/features/onboarding/presentation/cubit/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final CompleteOnboardingUseCase completeOnboardingUseCase;

  static const List<OnboardingItem> onboardingItems = [
    OnboardingItem(
      index: 0,
      title: 'سَكِينَةُ التِّلَاوَةِ',
      subtitle:
          'اسْتَمِعْ لِأَعْذَبِ الحَنَاجِرِ بِجَوْدَةٍ عَالِيَةٍ تَأْخُذُ قَلْبَكَ إِلَى عَالَمٍ مِنَ الطُّمَأْنِينَةِ وَالخُشُوعِ السَّامِي.',
      imageAsset: AppAssets.onboarding3,
      buttonText: 'التَّالِي',
    ),
    OnboardingItem(
      index: 1,
      title: 'مَلَاذُكَ لِلتَّدَبُّرِ وَالقُرْآنِ',
      subtitle:
          'عِشْ تَجْرِبَةَ قِرَاءَةٍ نَقِيَّةٍ وَانْغَمِسْ فِي حُرُوفِ الذِّكْرِ الحَكِيمِ بِلَا مُشَتِّتَاتٍ وَبِخُشُوعٍ تَامٍّ.',
      imageAsset: AppAssets.onboarding2,
      buttonText: 'التَّالِي',
    ),
    OnboardingItem(
      index: 2,
      title: 'طَرِيقُ العَوْدَةِ إِلَى اللهِ',
      subtitle:
          'خُطُوَاتٌ هَادِئَةٌ لِلتَّعَافِي، تَرْكِ المَعَاصِي، وَبِنَاءِ عَادَاتٍ تُقَرِّبُكَ مِنَ الخَالِقِ سُبْحَانَهُ.',
      imageAsset: AppAssets.onboarding1,
      buttonText: 'ابْدَأْ رِحْلَتَكَ 🕊️',
    ),
  ];

  OnboardingCubit({required this.completeOnboardingUseCase})
      : super(const OnboardingActive(
          currentIndex: 0,
          items: onboardingItems,
        ));

  void onPageChanged(int newIndex) {
    HapticService.selectionClick();
    emit(OnboardingActive(
      currentIndex: newIndex,
      items: onboardingItems,
    ));
  }

  Future<void> completeOnboarding() async {
    await HapticService.heavyImpact();
    final result = await completeOnboardingUseCase(const NoParams());
    result.fold(
      (failure) {
        // Fallback to Quran route
        emit(const OnboardingCompleted(destinationRoute: '/quran'));
      },
      (destinationRoute) {
        emit(OnboardingCompleted(destinationRoute: destinationRoute));
      },
    );
  }
}
