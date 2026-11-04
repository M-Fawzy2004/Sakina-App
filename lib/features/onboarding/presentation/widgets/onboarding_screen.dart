import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
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

  static String _toArabicDigits(int number) {
    const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    final str = number.toString().padLeft(2, '0');
    return str.split('').map((char) => digits[int.parse(char)]).join();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          context.go(state.destinationRoute);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.obsidianCore,
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final imageHeight =
                  (constraints.maxHeight * 0.43).clamp(240.0, 390.0);

              return BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) {
                  if (state is! OnboardingActive) {
                    return const SizedBox.shrink();
                  }

                  final cubit = context.read<OnboardingCubit>();

                  return Column(
                    children: [
                      // 1. Top Navigation Bar (Step Counter + Skip Button)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.frostedGlass,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: AppColors.goldBorderStroke,
                                  width: 1.r,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Iconsax.magic_star,
                                    size: 14.sp,
                                    color: AppColors.champagneGold,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    '${_toArabicDigits(state.currentIndex + 1)} / ${_toArabicDigits(state.items.length)}',
                                    style: GoogleFonts.cairo(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.champagneGold,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: state.isLastPage ? 0.0 : 1.0,
                              duration: const Duration(milliseconds: 250),
                              child: IgnorePointer(
                                ignoring: state.isLastPage,
                                child: OnboardingSkipButton(
                                  onSkip: cubit.completeOnboarding,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 2. Interactive PageView Slider
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
                                          _pageController.initialPage
                                              .toDouble()) -
                                      index;
                                }

                                final scale = (1.0 - (pageOffset.abs() * 0.08))
                                    .clamp(0.0, 1.0);
                                final opacity =
                                    (1.0 - (pageOffset.abs() * 0.40))
                                        .clamp(0.0, 1.0);

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

                      // 3. Centered Flat Page Indicator (Strictly Zero Shadow)
                      OnboardingIndicator(
                        count: state.items.length,
                        currentIndex: state.currentIndex,
                      ),

                      SizedBox(height: 18.h),

                      // 4. Primary Next / Finish Action Button
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

                      SizedBox(
                        height: bottomPadding > 0
                            ? bottomPadding + 10.h
                            : 20.h,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
