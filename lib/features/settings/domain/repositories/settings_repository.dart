import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';

abstract interface class SettingsRepository {
  Future<Either<Failure, AppThemeMode>> getThemeMode();
  Future<Either<Failure, void>> setThemeMode(AppThemeMode mode);
  Future<Either<Failure, Color>> getPrimaryAccentColor();
  Future<Either<Failure, void>> setPrimaryAccentColor(Color color);
  Future<Either<Failure, void>> resetSettings();
}
