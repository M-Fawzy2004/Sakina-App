import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';

/// Tactile luxury numeric keypad and 4-digit PIN indicator for Mihrab Sanctuary.
class MihrabNumericKeypad extends StatelessWidget {
  final String currentPin;
  final ValueChanged<String> onDigitPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback onClearPressed;

  const MihrabNumericKeypad({
    super.key,
    required this.currentPin,
    required this.onDigitPressed,
    required this.onBackspacePressed,
    required this.onClearPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 4-Dot PIN Indicator Display
        _PinDotsDisplay(filledCount: currentPin.length),
        SizedBox(height: 24.h),

        // Keypad Grid: 1-9, Clear, 0, Backspace
        _KeypadRow(
          digits: const ['1', '2', '3'],
          onDigitTap: onDigitPressed,
        ),
        SizedBox(height: 12.h),
        _KeypadRow(
          digits: const ['4', '5', '6'],
          onDigitTap: onDigitPressed,
        ),
        SizedBox(height: 12.h),
        _KeypadRow(
          digits: const ['7', '8', '9'],
          onDigitTap: onDigitPressed,
        ),
        SizedBox(height: 12.h),
        _BottomKeypadRow(
          onDigitTap: onDigitPressed,
          onBackspace: onBackspacePressed,
          onClear: onClearPressed,
        ),
      ],
    );
  }
}

class _PinDotsDisplay extends StatelessWidget {
  final int filledCount;

  const _PinDotsDisplay({required this.filledCount});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isFilled = index < filledCount;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          width: isFilled ? 18.r : 14.r,
          height: isFilled ? 18.r : 14.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? colors.accentGold : Colors.transparent,
            border: Border.all(
              color: isFilled
                  ? colors.accentGold
                  : colors.borderHairline.withValues(alpha: 0.7),
              width: 1.5.r,
            ),
          ),
        );
      }),
    );
  }
}

class _KeypadRow extends StatelessWidget {
  final List<String> digits;
  final ValueChanged<String> onDigitTap;

  const _KeypadRow({
    required this.digits,
    required this.onDigitTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: digits.map((d) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: _KeypadButton(
            label: d,
            onTap: () => onDigitTap(d),
          ),
        );
      }).toList(),
    );
  }
}

class _BottomKeypadRow extends StatelessWidget {
  final ValueChanged<String> onDigitTap;
  final VoidCallback onBackspace;
  final VoidCallback onClear;

  const _BottomKeypadRow({
    required this.onDigitTap,
    required this.onBackspace,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Clear / Cancel Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: _ActionButton(
            icon: Iconsax.trash,
            tooltip: 'مسح',
            color: colors.textSecondary,
            onTap: onClear,
          ),
        ),

        // Digit 0
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: _KeypadButton(
            label: '0',
            onTap: () => onDigitTap('0'),
          ),
        ),

        // Backspace Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: _ActionButton(
            icon: Iconsax.arrow_left_2,
            tooltip: 'حذف',
            color: colors.accentGold,
            onTap: onBackspace,
          ),
        ),
      ],
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _KeypadButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(32.r),
        child: Container(
          width: 64.r,
          height: 64.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surfaceElevated.withValues(alpha: 0.6),
            border: Border.all(
              color: colors.borderHairline.withValues(alpha: 0.5),
              width: 1.r,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.almarai(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(32.r),
        child: Container(
          width: 64.r,
          height: 64.r,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Center(
            child: Icon(icon, size: 22.r, color: color),
          ),
        ),
      ),
    );
  }
}
