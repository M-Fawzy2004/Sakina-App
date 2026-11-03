import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/core/utils/app_top_snack_bar.dart';
import 'package:sakina_app/core/utils/haptic_service.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_item_entity.dart';
import 'package:sakina_app/features/athkar/presentation/widgets/components/athkar_card_elements.dart';
import 'package:sakina_app/features/athkar/presentation/widgets/components/athkar_interactive_tasbih_row.dart';

/// Inspiring Tactile Dark Luxury Card for a sacred Thikr item.
/// Features:
/// 1. Ornamental Islamic Medallion Header with dynamic repetition badge.
/// 2. Clear, authentic Tashkeel typography with safe line-height.
/// 3. Soothing Virtue & Reward quote section.
/// 4. Interactive Concentric Tasbih Counter Medallion with haptic micro-pulses.
/// 5. Smooth Emerald Sanctuary completion transformation.
class AthkarItemCard extends StatelessWidget {
  final AthkarItemEntity item;
  final int itemIndex;
  final int currentRepetitions;
  final VoidCallback onTapCount;
  final VoidCallback onReset;

  const AthkarItemCard({
    super.key,
    required this.item,
    required this.itemIndex,
    required this.currentRepetitions,
    required this.onTapCount,
    required this.onReset,
  });

  void _copyThikr(BuildContext context) {
    HapticService.selectionClick();
    Clipboard.setData(ClipboardData(text: item.content));
    AppTopSnackBar.show(
      context: context,
      message: 'تَمَّ نَسْخُ الذِّكْرِ المُبَارَكِ لِلحَافِظَةِ',
      icon: Iconsax.copy,
      iconColor: AppColors.champagneGold,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isCompleted = currentRepetitions >= item.count;
    final remaining = (item.count - currentRepetitions).clamp(0, item.count);
    final progress = (currentRepetitions / item.count).clamp(0.0, 1.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isCompleted
                ? colors.accentEmerald.withValues(alpha: 0.35)
                : colors.borderHairline,
            width: isCompleted ? 1.4.r : 1.r,
          ),
        ),
        padding: EdgeInsets.all(18.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AthkarCardHeader(
              index: itemIndex,
              targetCount: item.count,
              isCompleted: isCompleted,
            ),
            SizedBox(height: 14.h),
            AthkarCardBodyText(content: item.content),
            if (item.description.isNotEmpty) ...[
              SizedBox(height: 14.h),
              AthkarVirtueBox(description: item.description),
            ],
            if (item.reference.isNotEmpty) ...[
              SizedBox(height: 8.h),
              AthkarReferencePill(reference: item.reference),
            ],
            SizedBox(height: 16.h),
            AthkarInteractiveTasbihRow(
              isCompleted: isCompleted,
              remaining: remaining,
              targetCount: item.count,
              progress: progress,
              currentRepetitions: currentRepetitions,
              onTapCount: onTapCount,
              onReset: onReset,
              onCopy: () => _copyThikr(context),
            ),
          ],
        ),
      ),
    );
  }
}
