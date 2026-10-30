import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sakina_app/core/di/injection_container.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:sakina_app/features/onboarding/presentation/cubit/onboarding_state.dart';
import 'package:sakina_app/features/onboarding/presentation/widgets/components/onboarding_action_button.dart';
import 'package:sakina_app/features/onboarding/presentation/widgets/components/onboarding_indicator.dart';
import 'package:sakina_app/features/onboarding/presentation/widgets/components/onboarding_page_content.dart';
import 'package:sakina_app/features/onboarding/presentation/widgets/components/onboarding_skip_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OnboardingCubit>(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          context.go(state.destinationRoute);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.obsidianCore,
        body: LayoutBuilder(
          builder: (context, constraints) {
            // Enhanced image height: ~53.5% of total screen height, clamped safely for all device dimensions
            final imageHeight = (constraints.maxHeight * 0.535).clamp(310.0, 520.0);

            return BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                if (state is! OnboardingActive) {
                  return const SizedBox.shrink();
                }

                final cubit = context.read<OnboardingCubit>();

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // 1. Interactive PageView Slider starting from absolute top y=0
                    Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            physics: const BouncingScrollPhysics(),
                            onPageChanged: cubit.onPageChanged,
                            itemCount: state.items.length,
                            itemBuilder: (context, index) {
                              return AnimatedBuilder(
                                animation: _pageController,
                                builder: (context, child) {
                                  double pageOffset = 0.0;
                                  if (_pageController.position.haveDimensions) {
                                    pageOffset = (_pageController.page ??
                                            _pageController.initialPage.toDouble()) -
                                        index;
                                  }

                                  final scale =
                                      (1.0 - (pageOffset.abs() * 0.10)).clamp(0.0, 1.0);
                                  final opacity =
                                      (1.0 - (pageOffset.abs() * 0.50)).clamp(0.0, 1.0);

                                  return Transform.scale(
                                    scale: scale,
                                    child: Opacity(
                                      opacity: opacity,
                                      child: child,
                                    ),
                                  );
                                },
                                child: OnboardingPageContent(
                                  item: state.items[index],
                                  imageHeight: imageHeight,
                                ),
                              );
                            },
                          ),
                        ),

                        // 2. Centered Animated Indicator (Directly below description)
                        OnboardingIndicator(
                          count: state.items.length,
                          currentIndex: state.currentIndex,
                        ),

                        SizedBox(height: 18.h),

                        // 3. Primary Next / Finish Action Button
                        OnboardingActionButton(
                          text: state.currentItem.buttonText,
                          isLastPage: state.isLastPage,
                          onPressed: () {
                            if (state.isLastPage) {
                              cubit.completeOnboarding();
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 380),
                                curve: Curves.easeInOutCubic,
                              );
                            }
                          },
                        ),

                        SizedBox(height: bottomPadding + 16.h),
                      ],
                    ),

                    // 4. Top Skip Action Button (Floating at top-end over image with safe area clearance)
                    PositionedDirectional(
                      top: topPadding + 10.h,
                      end: 18.w,
                      child: AnimatedOpacity(
                        opacity: state.isLastPage ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 250),
                        child: IgnorePointer(
                          ignoring: state.isLastPage,
                          child: OnboardingSkipButton(
                            onSkip: cubit.completeOnboarding,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
