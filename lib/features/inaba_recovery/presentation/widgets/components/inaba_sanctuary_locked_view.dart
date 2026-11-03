import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sakina_app/core/theme/app_colors.dart';
import 'package:sakina_app/core/theme/app_colors_scheme.dart';
import 'package:sakina_app/features/inaba_recovery/presentation/widgets/components/mihrab_numeric_keypad.dart';

/// Locked state view for the Inaba Sanctuary secured with an offline numeric PIN passcode.
class InabaSanctuaryLockedView extends StatefulWidget {
  final bool hasPin;
  final bool Function(String pin) onVerifyPin;
  final Future<bool> Function(String pin) onSetPin;
  final Future<void> Function() onResetPin;
  final Future<void> Function()? onBiometricTap;

  const InabaSanctuaryLockedView({
    super.key,
    required this.hasPin,
    required this.onVerifyPin,
    required this.onSetPin,
    required this.onResetPin,
    this.onBiometricTap,
  });

  @override
  State<InabaSanctuaryLockedView> createState() =>
      _InabaSanctuaryLockedViewState();
}

class _InabaSanctuaryLockedViewState extends State<InabaSanctuaryLockedView>
    with SingleTickerProviderStateMixin {
  String _enteredPin = '';
  String _firstSetupPin = '';
  bool _isConfirmingSetup = false;
  String? _errorMessage;

  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    if (widget.hasPin && widget.onBiometricTap != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onBiometricTap!();
        }
      });
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onDigitPressed(String digit) {
    if (_enteredPin.length >= 4) return;

    setState(() {
      _enteredPin += digit;
      _errorMessage = null;
    });

    if (_enteredPin.length == 4) {
      _processCompletedPin();
    }
  }

  void _onBackspacePressed() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _errorMessage = null;
      });
    }
  }

  void _onClearPressed() {
    setState(() {
      _enteredPin = '';
      _errorMessage = null;
    });
  }

  Future<void> _processCompletedPin() async {
    final pin = _enteredPin;

    if (!widget.hasPin) {
      // Setup Mode
      if (!_isConfirmingSetup) {
        setState(() {
          _firstSetupPin = pin;
          _isConfirmingSetup = true;
          _enteredPin = '';
          _errorMessage = null;
        });
      } else {
        if (pin == _firstSetupPin) {
          final success = await widget.onSetPin(pin);
          if (!success) {
            _triggerError('فشل حفظ الرمز محلياً، حاول ثانية');
          }
        } else {
          _triggerError('الرمزان غير متطابقين، أعد المحاولة');
          setState(() {
            _isConfirmingSetup = false;
            _firstSetupPin = '';
          });
        }
      }
    } else {
      // Verification Mode
      final isValid = widget.onVerifyPin(pin);
      if (!isValid) {
        _triggerError('رمز القفل غير صحيح، حاول ثانية');
      }
    }
  }

  void _triggerError(String message) {
    HapticFeedback.heavyImpact();
    _shakeController.forward(from: 0.0);
    setState(() {
      _errorMessage = message;
      _enteredPin = '';
    });
  }

  void _showResetConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: context.colors.cardSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
            side: BorderSide(color: context.colors.borderHairline),
          ),
          title: Text(
            'إعادة تعيين رمز المحراب',
            style: GoogleFonts.almarai(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: context.colors.textPrimary,
            ),
          ),
          content: Text(
            'لحماية خصوصيتك ومنع أي شخص آخر من تغيير الرمز، سيُطلب منك تأكيد هويتك عبر بصمة الوجه أو الإصبع أو رمز هاتفك الشخصي قبل إعادة التعيين.',
            style: GoogleFonts.almarai(
              fontSize: 13.sp,
              color: context.colors.textSecondary,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'إلغاء',
                style: TextStyle(color: context.colors.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.accentGold,
                foregroundColor: context.colors.background,
              ),
              onPressed: () async {
                Navigator.of(ctx).pop();
                await widget.onResetPin();
                setState(() {
                  _enteredPin = '';
                  _firstSetupPin = '';
                  _isConfirmingSetup = false;
                  _errorMessage = null;
                });
              },
              child: const Text('إعادة التعيين'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final String titleText;
    final String subtitleText;

    if (!widget.hasPin) {
      if (!_isConfirmingSetup) {
        titleText = 'تعيين رمز قفل المحراب';
        subtitleText = 'اختر ٤ أرقام لحماية مناجاتك ومحرابك الخاص محلياً';
      } else {
        titleText = 'تأكيد رمز القفل';
        subtitleText = 'أعد إدخال الرمز المكون من ٤ أرقام للتأكيد';
      }
    } else {
      titleText = 'محرابك محمي برمز أرقام';
      subtitleText = 'أدخل رمز القفل لفتح المحراب والاطلاع على مناجاتك';
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Shield Emblem Medallion
            Container(
              width: 58.r,
              height: 58.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surfaceElevated,
                border: Border.all(
                  color: colors.accentGold.withValues(alpha: 0.6),
                  width: 1.5.r,
                ),
              ),
              child: Center(
                child: Icon(
                  Iconsax.lock,
                  size: 26.r,
                  color: colors.accentGold,
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Title & Instruction
            Text(
              titleText,
              textAlign: TextAlign.center,
              style: GoogleFonts.almarai(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitleText,
              textAlign: TextAlign.center,
              style: GoogleFonts.almarai(
                fontSize: 11.5.sp,
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: 14.h),

            // Error Banner with Animated Shake
            if (_errorMessage != null) ...[
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final offset = 12.w *
                      (1.0 - _shakeController.value) *
                      ((_shakeController.value * 12).floor().isEven ? 1 : -1);
                  return Transform.translate(
                    offset: Offset(offset, 0),
                    child: child,
                  );
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.errorRed.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: AppColors.errorRed.withValues(alpha: 0.5),
                      width: 1.r,
                    ),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: GoogleFonts.almarai(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.errorRed,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ],

            // Tactile Keypad & PIN Dots
            MihrabNumericKeypad(
              currentPin: _enteredPin,
              onDigitPressed: _onDigitPressed,
              onBackspacePressed: _onBackspacePressed,
              onClearPressed: _onClearPressed,
            ),

            if (widget.hasPin && widget.onBiometricTap != null) ...[
              SizedBox(height: 12.h),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.accentGold,
                  side: BorderSide(
                    color: colors.accentGold.withValues(alpha: 0.5),
                    width: 1.r,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  widget.onBiometricTap!();
                },
                icon: Icon(
                  Iconsax.finger_scan,
                  size: 18.r,
                  color: colors.accentGold,
                ),
                label: Text(
                  'فتح بالبصمة أو رمز الهاتف',
                  style: GoogleFonts.almarai(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.accentGold,
                  ),
                ),
              ),
            ],

            SizedBox(height: 12.h),

            // Reset PIN link if user set one
            if (widget.hasPin)
              TextButton.icon(
                onPressed: _showResetConfirmDialog,
                icon: Icon(
                  Iconsax.key,
                  size: 15.r,
                  color: colors.textSecondary,
                ),
                label: Text(
                  'نسيت رمز القفل؟ إعادة التعيين',
                  style: GoogleFonts.almarai(
                    fontSize: 11.5.sp,
                    color: colors.textSecondary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
