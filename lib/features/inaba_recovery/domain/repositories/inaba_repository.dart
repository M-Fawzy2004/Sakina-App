import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/daily_hope_dose_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/good_deed_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/inaba_overview_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/repentance_step_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_level_entity.dart';
import 'package:sakina_app/features/inaba_recovery/domain/entities/spiritual_reflection_entity.dart';

/// Contract defining the repository operations for the Inaba & Recovery feature.
abstract interface class InabaRepository {
  Future<Either<Failure, InabaOverviewEntity>> getInabaOverview();
  Future<Either<Failure, List<GoodDeedEntity>>> getGoodDeeds();
  Future<Either<Failure, GoodDeedEntity>> toggleGoodDeed(String id);
  Future<Either<Failure, GoodDeedEntity>> addCustomGoodDeed(
    String title,
    String category,
  );
  Future<Either<Failure, List<DailyHopeDoseEntity>>> getHopeDoses();
  Future<Either<Failure, DailyHopeDoseEntity>> toggleSaveHopeDose(String id);
  Future<Either<Failure, List<SpiritualLevelEntity>>> getSpiritualLevels();
  Future<Either<Failure, List<SpiritualReflectionEntity>>> getReflections();
  Future<Either<Failure, SpiritualReflectionEntity>> saveReflection({
    required String title,
    required String content,
    required String moodTag,
  });
  Future<Either<Failure, Unit>> deleteReflection(String id);
  Future<Either<Failure, Unit>> clearAllReflections();
  Future<Either<Failure, List<RepentanceStepEntity>>> getRepentanceSteps();
  Future<Either<Failure, RepentanceStepEntity>> toggleRepentanceStep(String id);
  Future<Either<Failure, InabaOverviewEntity>> renewCovenant();
  Future<Either<Failure, InabaOverviewEntity>> logSpiritualVictory();
  Future<Either<Failure, InabaOverviewEntity>> activateRecoveryPath();
  Future<Either<Failure, InabaOverviewEntity>> advanceActiveDay();
}
