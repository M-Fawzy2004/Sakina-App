import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';

/// Quick target selector allowing the worshipper to cycle between standard targets
/// (33, 100, 1000, or unlimited/open).
class IstighfarTargetSelector extends StatelessWidget {
  final int currentTarget;
  final ValueChanged<int> onTargetSelected;

  const IstighfarTargetSelector({
    super.key,
    required this.currentTarget,
    required this.onTargetSelected,
  });

  static const List<({int target, String label})> _targets = [
    (target: 33, label: '33'),
    (target: 100, label: '100'),
    (target: 1000, label: '1000'),
    (target: 0, label: 'مفتوح'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: colors.borderHairline.withValues(alpha: 0.6),
            width: 0.8.r,
          ),
        ),
        child: Row(
          children: _targets.map((t) {
            final isSelected = currentTarget == t.target;

            return Expanded(
              child: InkWell(
                onTap: () => onTargetSelected(t.target),
                borderRadius: BorderRadius.circular(11.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.accentGold.withValues(alpha: 0.18)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(11.r),
                    border: isSelected
                        ? Border.all(
                            color: colors.accentGold,
                            width: 1.2.r,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      t.label,
                      style: GoogleFonts.cairo(
                        color: isSelected
                            ? colors.accentGold
                            : colors.textSecondary,
                        fontSize: 13.sp,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

