import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/theme/app_text_styles.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_cubit.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/cubit/inaba_state.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_hope_background_selector.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_hope_card_exporter.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/inaba_hope_card_view.dart';

/// Modal bottom sheet showcasing daily hope dose cards with custom background selection & image export.
class InabaDailyHopeSheet extends StatefulWidget {
  const InabaDailyHopeSheet({super.key});

  static Future<void> show(
    BuildContext context, {
    required InabaCubit cubit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const InabaDailyHopeSheet(),
      ),
    );
  }

  @override
  State<InabaDailyHopeSheet> createState() => _InabaDailyHopeSheetState();
}

class _InabaDailyHopeSheetState extends State<InabaDailyHopeSheet> {
  final GlobalKey _cardKey = GlobalKey();
  String? _selectedBackground =
      InabaHopeBackgroundSelector.backgroundAssets.first;
  bool _isExporting = false;

  Future<void> _handleSaveCard() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    await InabaHopeCardExporter.saveToGallery(
      context: context,
      boundaryKey: _cardKey,
    );
    if (mounted) {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _handleShareCard(String verseSource) async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    await InabaHopeCardExporter.shareCard(
      context: context,
      boundaryKey: _cardKey,
      verseSource: verseSource,
    );
    if (mounted) {
      setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return BlocBuilder<InabaCubit, InabaState>(
      builder: (context, state) {
        final activeDose = state.activeHopeDose;
        final cubit = context.read<InabaCubit>();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: 0.88.sh,
            padding: EdgeInsets.only(
              left: 18.w,
              right: 18.w,
              top: 14.h,
              bottom: bottomInset > 0 ? bottomInset + 10.h : 18.h,
            ),
            decoration: BoxDecoration(
              color: colors.cardSurface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              border: Border.all(color: colors.borderHairline, width: 1.r),
            ),
            child: Column(
              children: [
                // Handle Bar
                Center(
                  child: Container(
                    width: 44.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: colors.borderHairline,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(7.r),
                          decoration: BoxDecoration(
                            color: colors.surfaceElevated,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: colors.borderHairline,
                              width: 1.r,
                            ),
                          ),
                          child: Icon(
                            Iconsax.gift,
                            size: 20.r,
                            color: colors.accentGold,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'جُرْعَةُ أَمَلٍ يَوْمِيَّةٍ',
                              style:
                                  AppTextStyles.titleMediumOf(context).copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                color: colors.textPrimary,
                              ),
                            ),
                            Text(
                              'حديث شريف أو آية ملهمة لتقوية قلبك وبعث الرجاء',
                              style: AppTextStyles.captionOf(context).copyWith(
                                color: colors.textSecondary,
                                fontSize: 10.5.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Iconsax.close_circle,
                        size: 20.r,
                        color: colors.textSecondary,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Hope Dose Manuscript Card
                if (activeDose != null)
                  Expanded(
                    child: InabaHopeCardView(
                      cardKey: _cardKey,
                      activeDose: activeDose,
                      selectedBackground: _selectedBackground,
                    ),
                  ),

                SizedBox(height: 12.h),

                // Background Thumbnails Selector
                InabaHopeBackgroundSelector(
                  selectedAsset: _selectedBackground,
                  onSelect: (bg) => setState(() => _selectedBackground = bg),
                ),

                SizedBox(height: 12.h),

                // Bottom Actions: Next, Save as Image, Bookmark
                Row(
                  children: [
                    // Next Card Button
                    Expanded(
                      flex: 3,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.accentGold,
                          foregroundColor: colors.background,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 11.h),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          cubit.nextHopeDose();
                        },
                        icon: Icon(
                          Iconsax.refresh,
                          size: 17.r,
                          color: colors.background,
                        ),
                        label: Text(
                          'تَالِيَةٌ',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: colors.background,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Export / Save Card as Image Button
                    Expanded(
                      flex: 3,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.accentGold,
                          side: BorderSide(
                            color: colors.accentGold.withValues(alpha: 0.7),
                            width: 1.r,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 11.h),
                        ),
                        onPressed: _isExporting || activeDose == null
                            ? null
                            : _handleSaveCard,
                        icon: _isExporting
                            ? SizedBox(
                                width: 14.r,
                                height: 14.r,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.r,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    colors.accentGold,
                                  ),
                                ),
                              )
                            : Icon(
                                Iconsax.gallery_export,
                                size: 17.r,
                                color: colors.accentGold,
                              ),
                        label: Text(
                          _isExporting ? 'جاري الحفظ...' : 'حفظ كصورة',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: colors.accentGold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Share Card Button
                    IconButton(
                      tooltip: 'مشاركة البطاقة',
                      style: IconButton.styleFrom(
                        backgroundColor: colors.surfaceElevated,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          side: BorderSide(
                            color: colors.borderHairline,
                            width: 1.r,
                          ),
                        ),
                        padding: EdgeInsets.all(11.r),
                      ),
                      onPressed: activeDose == null
                          ? null
                          : () => _handleShareCard(activeDose.source),
                      icon: Icon(
                        Iconsax.share,
                        size: 19.r,
                        color: colors.textSecondary,
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Bookmark Button
                    IconButton(
                      tooltip:
                          activeDose?.isSaved == true ? 'محفوظة' : 'حفظ',
                      style: IconButton.styleFrom(
                        backgroundColor: colors.surfaceElevated,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          side: BorderSide(
                            color: activeDose?.isSaved == true
                                ? colors.accentGold
                                : colors.borderHairline,
                            width: 1.r,
                          ),
                        ),
                        padding: EdgeInsets.all(11.r),
                      ),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        cubit.toggleSaveCurrentHopeDose();
                      },
                      icon: Icon(
                        activeDose?.isSaved == true
                            ? Iconsax.archive_tick
                            : Iconsax.archive_1,
                        size: 19.r,
                        color: activeDose?.isSaved == true
                            ? colors.accentGold
                            : colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
