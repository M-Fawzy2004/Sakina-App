import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_spacing.dart';

/// Tactile glass search input for reciters and surahs without drop shadows.
class RecitersSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const RecitersSearchBar({
    super.key,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<RecitersSearchBar> createState() => _RecitersSearchBarState();
}

class _RecitersSearchBarState extends State<RecitersSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
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
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.carbonSlate,
          borderRadius: AppSpacing.radiusMd,
          border: Border.all(
            color: AppColors.goldBorderStroke,
            width: 1.r,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          children: [
            Icon(
              Iconsax.search_normal_1,
              color: AppColors.champagneGold,
              size: 20.r,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: TextField(
                controller: _controller,
                textAlignVertical: TextAlignVertical.center,
                style: GoogleFonts.cairo(
                  color: AppColors.pureChalk,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'ابحث عن قارئ أو سورة...',
                  hintStyle: GoogleFonts.cairo(
                    color: AppColors.mutedSilver,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (text) {
                  setState(() {});
                  widget.onChanged(text);
                },
              ),
            ),
            if (_controller.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _controller.clear();
                  setState(() {});
                  widget.onClear();
                },
                child: Icon(
                  Iconsax.close_circle,
                  color: AppColors.mutedSilver,
                  size: 18.r,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
