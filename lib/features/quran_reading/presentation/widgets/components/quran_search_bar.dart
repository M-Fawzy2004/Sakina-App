import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';

/// Tactile luxury search field for filtering Surahs and Juzs.
class QuranSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String currentQuery;

  const QuranSearchBar({
    super.key,
    required this.onChanged,
    required this.currentQuery,
  });

  @override
  State<QuranSearchBar> createState() => _QuranSearchBarState();
}

class _QuranSearchBarState extends State<QuranSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentQuery);
  }

  @override
  void didUpdateWidget(covariant QuranSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentQuery != widget.currentQuery &&
        _controller.text != widget.currentQuery) {
      _controller.text = widget.currentQuery;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 46.h,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColors.goldBorderStroke,
            width: 1.r,
          ),
        ),
        child: TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.pureChalk,
            fontSize: 13.sp,
          ),
          cursorColor: AppColors.champagneGold,
          decoration: InputDecoration(
            hintText: 'ابْحَثْ عَنِ السُّورَةِ (بِالاسْمِ أَوْ الرَّقْمِ)...',
            hintStyle: AppTextStyles.caption.copyWith(
              color: AppColors.mutedSilver,
              fontSize: 12.sp,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Icon(
                Iconsax.search_normal,
                color: AppColors.champagneGold,
                size: 18.r,
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: 42.w,
              minHeight: 24.h,
            ),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Iconsax.close_circle,
                      color: AppColors.mutedSilver,
                      size: 18.r,
                    ),
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12.h),
          ),
        ),
      ),
    );
  }
}

