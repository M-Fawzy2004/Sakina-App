import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:sakina_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:sakina_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:sakina_app/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  const SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, AppThemeMode>> getThemeMode() async {
    try {
      final mode = await localDataSource.getThemeMode();
      return Right(mode);
    } catch (e) {
      AppLogger.error('SettingsRepository: getThemeMode failed', e);
      return const Left(CacheFailure(message: 'تعذر استرجاع مظهر التطبيق المحفوظ'));
    }
  }

  @override
  Future<Either<Failure, void>> setThemeMode(AppThemeMode mode) async {
    try {
      await localDataSource.setThemeMode(mode);
      return const Right(null);
    } catch (e) {
      AppLogger.error('SettingsRepository: setThemeMode failed', e);
      return const Left(CacheFailure(message: 'تعذر حفظ مظهر التطبيق'));
    }
  }

  @override
  Future<Either<Failure, Color>> getPrimaryAccentColor() async {
    try {
      final color = await localDataSource.getPrimaryAccentColor();
      return Right(color);
    } catch (e) {
      AppLogger.error('SettingsRepository: getPrimaryAccentColor failed', e);
      return const Left(CacheFailure(message: 'تعذر استرجاع اللون المخصص'));
    }
  }

  @override
  Future<Either<Failure, void>> setPrimaryAccentColor(Color color) async {
    try {
      await localDataSource.setPrimaryAccentColor(color);
      return const Right(null);
    } catch (e) {
      AppLogger.error('SettingsRepository: setPrimaryAccentColor failed', e);
      return const Left(CacheFailure(message: 'تعذر حفظ اللون المخصص'));
    }
  }

  @override
  Future<Either<Failure, void>> resetSettings() async {
    try {
      await localDataSource.resetSettings();
      return const Right(null);
    } catch (e) {
      AppLogger.error('SettingsRepository: resetSettings failed', e);
      return const Left(CacheFailure(message: 'تعذر إعادة ضبط الإعدادات'));
    }
  }
}
