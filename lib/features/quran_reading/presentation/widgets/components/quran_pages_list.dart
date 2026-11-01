import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/quran_bookmark_entity.dart';
import 'package:sakina_app/features/quran_reading/domain/entities/surah_entity.dart';
import 'package:sakina_app/features/quran_reading/presentation/cubit/quran_cubit.dart';

/// Dedicated Interactive Page Selector View for the «الصفحات» Tab.
/// Replaces the long 604-item list with a luxury Cupertino wheel selector,
/// direct page input dialog, instant page jump action, and one-tap bookmarking.
class QuranPagesList extends StatefulWidget {
  final List<SurahEntity> allSurahs;
  final ValueChanged<int> onPageTap;
  final int initialPage;

  const QuranPagesList({
    super.key,
    required this.allSurahs,
    required this.onPageTap,
    this.initialPage = 1,
  });

  @override
  State<QuranPagesList> createState() => _QuranPagesListState();
}

class _QuranPagesListState extends State<QuranPagesList> {
  late int _selectedPage;
  late final FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedPage = widget.initialPage.clamp(1, 604);
    _scrollController = FixedExtentScrollController(
      initialItem: _selectedPage - 1,
    );
  }

  @override
  void didUpdateWidget(QuranPagesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPage != widget.initialPage &&
        widget.initialPage != _selectedPage) {
      _selectedPage = widget.initialPage.clamp(1, 604);
      if (_scrollController.hasClients) {
        _scrollController.jumpToItem(_selectedPage - 1);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showPageInputDialog(BuildContext context) async {
    final textController = TextEditingController(text: '$_selectedPage');
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) {
        final colors = ctx.colors;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: colors.cardSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
              side: BorderSide(
                color: colors.borderHairline,
                width: 1.r,
              ),
            ),
            title: Text(
              'الانتقال إلى صفحة',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'أدخل رقم الصفحة من 1 إلى 604',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: textController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 3,
                  style: GoogleFonts.cairo(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: colors.accentGold,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '1 - 604',
                    hintStyle: GoogleFonts.cairo(
                      color: colors.textSecondary.withValues(alpha: 0.5),
                      fontSize: 14.sp,
                    ),
                    filled: true,
                    fillColor: colors.surfaceElevated,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: colors.borderHairline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: colors.accentGold,
                        width: 1.5.r,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  onSubmitted: (val) {
                    final page = int.tryParse(val);
                    if (page != null && page >= 1 && page <= 604) {
                      Navigator.of(ctx).pop(page);
                    }
                  },
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  'إلغاء',
                  style: GoogleFonts.cairo(
                    color: colors.textSecondary,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              ElevatedButton(
                onPressed: () {
                  final page = int.tryParse(textController.text);
                  if (page != null && page >= 1 && page <= 604) {
                    Navigator.of(ctx).pop(page);
                  } else {
                    AppTopSnackBar.show(
                      context: context,
                      message: 'يرجى إدخال رقم صفحة صحيح بين 1 و 604',
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.accentGold,
                  foregroundColor: colors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                ),
                child: Text(
                  'تأكيد',
                  style: GoogleFonts.cairo(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null && mounted) {
      setState(() {
        _selectedPage = result;
      });
      _scrollController.animateToItem(
        result - 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _saveBookmark() {
    HapticService.selectionClick();
    final targetSurah = widget.allSurahs.lastWhere(
      (s) => s.pageNumber <= _selectedPage,
      orElse: () => widget.allSurahs.first,
    );

    final bookmark = QuranBookmarkEntity(
      surahId: targetSurah.id,
      surahName: targetSurah.nameArabic,
      ayahNumber: 1,
      pageNumber: _selectedPage,
      timestamp: DateTime.now(),
    );

    context.read<QuranCubit>().saveBookmark(bookmark);

    AppTopSnackBar.show(
      context: context,
      message:
          'تم حفظ الصفحة $_selectedPage (سورة ${targetSurah.nameArabic}) في الإشارات المرجعية بنجاح',
      icon: Iconsax.bookmark_2,
      iconColor: context.colors.accentGold,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Column(
          children: [
            // 1. Wheel Page Picker with Selection Zone Capsule
            SizedBox(
              height: 156.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Center selection capsule indicator
                  IgnorePointer(
                    child: Container(
                      width: double.infinity,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: colors.borderHairline.withValues(alpha: 0.7),
                          width: 1.r,
                        ),
                      ),
                    ),
                  ),

                  // Interactive wheel scroll view
                  ListWheelScrollView.useDelegate(
                    controller: _scrollController,
                    itemExtent: 52.h,
                    perspective: 0.002,
                    diameterRatio: 2.0,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      final page = index + 1;
                      if (page != _selectedPage) {
                        setState(() {
                          _selectedPage = page;
                        });
                        HapticService.selectionClick();
                      }
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 604,
                      builder: (context, index) {
                        final page = index + 1;
                        final isSelected = page == _selectedPage;

                        return Center(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (isSelected) {
                                HapticService.selectionClick();
                                widget.onPageTap(page);
                              } else {
                                _scrollController.animateToItem(
                                  index,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 52.h,
                              alignment: Alignment.center,
                              child: Text(
                                'الصفحة $page',
                                style: GoogleFonts.cairo(
                                  fontSize: isSelected ? 16.sp : 14.5.sp,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? colors.textPrimary
                                      : colors.textSecondary
                                          .withValues(alpha: 0.45),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // 2. Button 1: "اكتب رقم الصفحة"
            _PageActionButton(
              title: 'اكتب رقم الصفحة',
              onTap: () => _showPageInputDialog(context),
            ),

            SizedBox(height: 12.h),

            // 3. Button 2: "اذهب إلى الصفحة [X]"
            _PageActionButton(
              title: 'اذهب إلى الصفحة $_selectedPage',
              onTap: () {
                HapticService.selectionClick();
                widget.onPageTap(_selectedPage);
              },
            ),

            SizedBox(height: 12.h),

            // 4. Button 3: "احفظ رقم الصفحة"
            _PageActionButton(
              title: 'احفظ رقم الصفحة',
              onTap: _saveBookmark,
            ),

            SizedBox(height: 24.h),

            // 5. Explanatory Note Text matching the reference design
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'يمكنك حفظ رقم الصفحة التي ترغب بالرجوع إليها لاحقًا،\nأو اضغط مرة للدخول إلى الصفحة في المصحف.',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.textSecondary.withValues(alpha: 0.7),
                  height: 1.6,
                ),
              ),
            ),

            SizedBox(height: 36.h),
          ],
        ),
      ),
    );
  }
}

/// Tactile, full-width rounded action capsule button.
class _PageActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _PageActionButton({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          height: 52.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.cardSurface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: colors.borderHairline.withValues(alpha: 0.65),
              width: 1.r,
            ),
          ),
          child: Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
