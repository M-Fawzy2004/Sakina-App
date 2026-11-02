import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/core/widgets/glass/tactile_glass_card.dart';
import 'package:sakina_app/features/hisn_muslim/domain/entities/hisn_dua_entity.dart';

class HisnDuaCard extends StatefulWidget {
  final HisnDuaEntity dua;
  final int index;
  final int totalInChapter;

  const HisnDuaCard({
    super.key,
    required this.dua,
    required this.index,
    required this.totalInChapter,
  });

  @override
  State<HisnDuaCard> createState() => _HisnDuaCardState();
}

class _HisnDuaCardState extends State<HisnDuaCard> {
  int _counter = 0;

  void _incrementCounter() {
    HapticService.lightImpact();
    setState(() {
      _counter++;
    });
  }

  void _resetCounter() {
    HapticService.selectionClick();
    setState(() {
      _counter = 0;
    });
  }

  void _copyToClipboard(BuildContext context) {
    HapticService.selectionClick();
    final text = '${widget.dua.arabic}\n\n${widget.dua.reference}';
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'تم نسخ الذكر إلى الحافظة',
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: context.colors.cardSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: context.colors.accentGold, width: 1.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TactileGlassCard(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Row: Dua Index Badge & Chapter Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: colors.borderHairline,
                    width: 1.r,
                  ),
                ),
                child: Text(
                  'ذكر ${widget.index} من ${widget.totalInChapter}',
                  style: AppTextStyles.captionOf(context).copyWith(
                    color: colors.accentGold,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Iconsax.copy,
                      size: 18.r,
                      color: colors.textSecondary,
                    ),
                    onPressed: () => _copyToClipboard(context),
                    tooltip: 'نسخ',
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.all(6.r),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Main Arabic Text with Tashkeel
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: colors.surfaceElevated.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: colors.borderHairline,
                width: 0.8.r,
              ),
            ),
            child: Text(
              widget.dua.arabic,
              textAlign: TextAlign.center,
              style: AppTextStyles.quranAyahOf(context).copyWith(
                fontSize: 16.5.sp,
                height: 1.8,
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: 12.h),

          // Reference / Source if available
          if (widget.dua.reference.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                widget.dua.reference,
                style: AppTextStyles.captionOf(context).copyWith(
                  color: colors.accentGold,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          SizedBox(height: 12.h),

          // Repetition Counter & Reset
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_counter > 0)
                TextButton.icon(
                  onPressed: _resetCounter,
                  icon: Icon(
                    Iconsax.refresh,
                    size: 14.r,
                    color: colors.textSecondary,
                  ),
                  label: Text(
                    'تصفير',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
              InkWell(
                borderRadius: BorderRadius.circular(20.r),
                onTap: _incrementCounter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: colors.accentGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: colors.accentGold,
                      width: 1.2.r,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.finger_cricle,
                        size: 16.r,
                        color: colors.accentGold,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        _counter == 0 ? 'تسبيح' : 'تكرار: $_counter',
                        style: AppTextStyles.captionOf(context).copyWith(
                          color: colors.accentGold,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

