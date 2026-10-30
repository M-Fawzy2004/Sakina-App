import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/maladh/domain/entities/maladh_header_data.dart';

/// Pure domain repository interface for Al-Maladh feature.
abstract interface class MaladhRepository {
  /// Retrieves dynamic header spiritual context, Hijri calendar status, and daily reflection.
  Future<Either<Failure, MaladhHeaderData>> getHeaderData();
}

