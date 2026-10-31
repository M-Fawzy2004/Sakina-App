import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

class InabaEmergencyHavenCard extends StatefulWidget {
  final VoidCallback onTap;

  const InabaEmergencyHavenCard({
    super.key,
    required this.onTap,
  });

  @override
  State<InabaEmergencyHavenCard> createState() => _InabaEmergencyHavenCardState();
}

class _InabaEmergencyHavenCardState extends State<InabaEmergencyHavenCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24.r),
            onTap: () {
              HapticFeedback.heavyImpact();
              widget.onTap();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
              decoration: BoxDecoration(
                color: colors.cardSurface,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: colors.accentGold.withValues(alpha: 0.5),
                  width: 1.5.r,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated Pulsing Central Golden Sphere
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 90.r,
                      height: 90.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.surfaceElevated,
                        border: Border.all(
                          color: colors.accentGold,
                          width: 2.r,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Concentric fine decorative circle
                          Container(
                            width: 74.r,
                            height: 74.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colors.accentGold.withValues(alpha: 0.35),
                                width: 1.r,
                              ),
                            ),
                          ),
                          Icon(
                            FlutterIslamicIcons.prayingPerson,
                            size: 38.r,
                            color: colors.accentGold,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Main Text
                  Text(
                    'أَشْعُرُ بِضَعْفٍ الآن',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 19.sp,
                      color: colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // Action hint pill
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: colors.borderHairline,
                        width: 1.r,
                      ),
                    ),
                    child: Text(
                      'اضغط هنا للُّجوء الفوري إلى الله',
                      style: AppTextStyles.caption.copyWith(
                        color: colors.accentGold,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
