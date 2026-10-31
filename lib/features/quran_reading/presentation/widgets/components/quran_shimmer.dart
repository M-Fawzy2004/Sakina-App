import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';

/// Shimmer skeleton loader for Quran catalog while dataset resolves.
class QuranShimmer extends StatelessWidget {
  const QuranShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceElevated,
      highlightColor: AppColors.carbonSlate,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                        color: AppColors.surfaceElevated,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 130.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          width: 90.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ],
            ),

            AppSpacing.verticalMd,

            // Last Read Skeleton
            Container(
              height: 72.h,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),

            AppSpacing.verticalSm,

            // Search Bar Skeleton
            Container(
              height: 46.h,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),

            AppSpacing.verticalSm,

            // Tab Bar Skeleton
            Container(
              height: 42.h,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),

            AppSpacing.verticalMd,

            // List Skeleton Tiles
            ...List.generate(6, (_) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Container(
                    height: 64.h,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

