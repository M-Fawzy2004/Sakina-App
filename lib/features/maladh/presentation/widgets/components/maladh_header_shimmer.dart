import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';

/// Shimmer loading skeleton for the sanctuary header while data initializes.
class MaladhHeaderShimmer extends StatelessWidget {
  const MaladhHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.carbonSlate,
      highlightColor: AppColors.surfaceElevated,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          children: [
            // Top Bar Skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: const BoxDecoration(
                        color: AppColors.carbonSlate,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      width: 80.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: AppColors.carbonSlate,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: AppColors.carbonSlate,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: const BoxDecoration(
                        color: AppColors.carbonSlate,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 14.h),

            // Greeting Hero Skeleton
            Container(
              height: 130.h,
              decoration: BoxDecoration(
                color: AppColors.carbonSlate,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),

            AppSpacing.verticalSm,

            // Reflection Card Skeleton
            Container(
              height: 140.h,
              decoration: BoxDecoration(
                color: AppColors.carbonSlate,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

