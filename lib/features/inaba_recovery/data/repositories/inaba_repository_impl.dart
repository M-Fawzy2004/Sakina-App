import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/core/utils/app_logger.dart';
import 'package:sakina_app/features/inaba_recovery/data/datasources/inaba_local_data_source.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/daily_hope_dose_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/good_deed_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/inaba_overview_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/repentance_step_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_level_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_reflection_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/repositories/inaba_repository.dart';

class InabaRepositoryImpl implements InabaRepository {
  final InabaLocalDataSource localDataSource;

  const InabaRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, InabaOverviewEntity>> getInabaOverview() async {
    try {
      final overview = await localDataSource.getInabaOverview();
      return Right(overview);
    } catch (e) {
      AppLogger.error('InabaRepository: getInabaOverview failed', e);
      return const Left(CacheFailure(message: 'تعذر تحميل بيانات الإنابة'));
    }
  }

  @override
  Future<Either<Failure, List<GoodDeedEntity>>> getGoodDeeds() async {
    try {
      final deeds = await localDataSource.getGoodDeeds();
      return Right(deeds);
    } catch (e) {
      AppLogger.error('InabaRepository: getGoodDeeds failed', e);
      return const Left(CacheFailure(message: 'تعذر تحميل قائمة الحسنات'));
    }
  }

  @override
  Future<Either<Failure, GoodDeedEntity>> toggleGoodDeed(String id) async {
    try {
      final deed = await localDataSource.toggleGoodDeed(id);
      return Right(deed);
    } catch (e) {
      AppLogger.error('InabaRepository: toggleGoodDeed failed', e);
      return const Left(CacheFailure(message: 'تعذر تحديث إنجاز الحسنة'));
    }
  }

  @override
  Future<Either<Failure, GoodDeedEntity>> addCustomGoodDeed(
    String title,
    String category,
  ) async {
    try {
      final deed = await localDataSource.addCustomGoodDeed(title, category);
      return Right(deed);
    } catch (e) {
      AppLogger.error('InabaRepository: addCustomGoodDeed failed', e);
      return const Left(CacheFailure(message: 'تعذر إضافة العمل الصالح'));
    }
  }

  @override
  Future<Either<Failure, List<DailyHopeDoseEntity>>> getHopeDoses() async {
    try {
      final doses = await localDataSource.getHopeDoses();
      return Right(doses);
    } catch (e) {
      AppLogger.error('InabaRepository: getHopeDoses failed', e);
      return const Left(CacheFailure(message: 'تعذر تحميل جرعات الأمل'));
    }
  }

  @override
  Future<Either<Failure, DailyHopeDoseEntity>> toggleSaveHopeDose(
    String id,
  ) async {
    try {
      final dose = await localDataSource.toggleSaveHopeDose(id);
      return Right(dose);
    } catch (e) {
      AppLogger.error('InabaRepository: toggleSaveHopeDose failed', e);
      return const Left(CacheFailure(message: 'تعذر حفظ جرعة الأمل'));
    }
  }

  @override
  Future<Either<Failure, List<SpiritualLevelEntity>>>
  getSpiritualLevels() async {
    try {
      final levels = await localDataSource.getSpiritualLevels();
      return Right(levels);
    } catch (e) {
      AppLogger.error('InabaRepository: getSpiritualLevels failed', e);
      return const Left(CacheFailure(message: 'تعذر تحميل المستويات الإيمانية'));
    }
  }

  @override
  Future<Either<Failure, List<SpiritualReflectionEntity>>>
  getReflections() async {
    try {
      final reflections = await localDataSource.getReflections();
      return Right(reflections);
    } catch (e) {
      AppLogger.error('InabaRepository: getReflections failed', e);
      return const Left(CacheFailure(message: 'تعذر تحميل خواطر المحراب'));
    }
  }

  @override
  Future<Either<Failure, SpiritualReflectionEntity>> saveReflection({
    required String title,
    required String content,
    required String moodTag,
  }) async {
    try {
      final reflection = await localDataSource.saveReflection(
        title: title,
        content: content,
        moodTag: moodTag,
      );
      return Right(reflection);
    } catch (e) {
      AppLogger.error('InabaRepository: saveReflection failed', e);
      return const Left(CacheFailure(message: 'تعذر حفظ الخاطرة'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteReflection(String id) async {
    try {
      await localDataSource.deleteReflection(id);
      return const Right(unit);
    } catch (e) {
      AppLogger.error('InabaRepository: deleteReflection failed', e);
      return const Left(CacheFailure(message: 'تعذر حذف الخاطرة'));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearAllReflections() async {
    try {
      await localDataSource.clearAllReflections();
      return const Right(unit);
    } catch (e) {
      AppLogger.error('InabaRepository: clearAllReflections failed', e);
      return const Left(CacheFailure(message: 'تعذر محو خواطر المحراب'));
    }
  }

  @override
  Future<Either<Failure, List<RepentanceStepEntity>>>
  getRepentanceSteps() async {
    try {
      final steps = await localDataSource.getRepentanceSteps();
      return Right(steps);
    } catch (e) {
      AppLogger.error('InabaRepository: getRepentanceSteps failed', e);
      return const Left(CacheFailure(message: 'تعذر تحميل خطوات التوبة'));
    }
  }

  @override
  Future<Either<Failure, RepentanceStepEntity>> toggleRepentanceStep(
    String id,
  ) async {
    try {
      final step = await localDataSource.toggleRepentanceStep(id);
      return Right(step);
    } catch (e) {
      AppLogger.error('InabaRepository: toggleRepentanceStep failed', e);
      return const Left(CacheFailure(message: 'تعذر تحديث خطوة التوبة'));
    }
  }

  @override
  Future<Either<Failure, InabaOverviewEntity>> renewCovenant() async {
    try {
      final overview = await localDataSource.renewCovenant();
      return Right(overview);
    } catch (e) {
      AppLogger.error('InabaRepository: renewCovenant failed', e);
      return const Left(CacheFailure(message: 'تعذر تجديد العهد'));
    }
  }

  @override
  Future<Either<Failure, InabaOverviewEntity>> logSpiritualVictory() async {
    try {
      final overview = await localDataSource.logSpiritualVictory();
      return Right(overview);
    } catch (e) {
      AppLogger.error('InabaRepository: logSpiritualVictory failed', e);
      return const Left(CacheFailure(message: 'تعذر تسجيل النصر الروحي'));
    }
  }

  @override
  Future<Either<Failure, InabaOverviewEntity>> activateRecoveryPath() async {
    try {
      final overview = await localDataSource.activateRecoveryPath();
      return Right(overview);
    } catch (e) {
      AppLogger.error('InabaRepository: activateRecoveryPath failed', e);
      return const Left(CacheFailure(message: 'تعذر بدء مسار الإنابة'));
    }
  }

  @override
  Future<Either<Failure, InabaOverviewEntity>> advanceActiveDay() async {
    try {
      final overview = await localDataSource.advanceActiveDay();
      return Right(overview);
    } catch (e) {
      AppLogger.error('InabaRepository: advanceActiveDay failed', e);
      return const Left(CacheFailure(message: 'تعذر الانتقال لليوم التالي'));
    }
  }
}
