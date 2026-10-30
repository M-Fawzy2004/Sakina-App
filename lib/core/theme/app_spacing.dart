import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized Spacing and Layout Metric Tokens scaled via ScreenUtil.
abstract final class AppSpacing {
  // Numeric metric tokens
  static double get xxs => 4.r;
  static double get xs  => 8.r;
  static double get sm  => 12.r;
  static double get md  => 16.r;
  static double get lg  => 24.r;
  static double get xl  => 32.r;
  static double get xxl => 48.r;

  // Pre-built vertical gap widgets
  static Widget get verticalXs  => SizedBox(height: 8.h);
  static Widget get verticalSm  => SizedBox(height: 12.h);
  static Widget get verticalMd  => SizedBox(height: 16.h);
  static Widget get verticalLg  => SizedBox(height: 24.h);
  static Widget get verticalXl  => SizedBox(height: 32.h);
  static Widget get verticalXxl => SizedBox(height: 48.h);

  // Pre-built horizontal gap widgets
  static Widget get horizontalXs => SizedBox(width: 8.w);
  static Widget get horizontalSm => SizedBox(width: 12.w);
  static Widget get horizontalMd => SizedBox(width: 16.w);
  static Widget get horizontalLg => SizedBox(width: 24.w);
  static Widget get horizontalXl => SizedBox(width: 32.w);

  // Unified padding presets
  static EdgeInsets get screenPadding => EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);
  static EdgeInsets get cardPadding   => EdgeInsets.all(16.r);
  static EdgeInsets get dialogPadding => EdgeInsets.all(24.r);

  // Unified radius presets
  static BorderRadius get radiusSm => BorderRadius.circular(12.r);
  static BorderRadius get radiusMd => BorderRadius.circular(16.r);
  static BorderRadius get radiusLg => BorderRadius.circular(20.r);
  static BorderRadius get radiusXl => BorderRadius.circular(28.r);
}

