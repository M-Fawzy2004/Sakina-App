import 'package:sakina_app/core/errors/failures.dart';

/// Domain failures specific to Al-Maladh (The Sanctuary) feature.
sealed class MaladhFailure extends Failure {
  const MaladhFailure({required super.message, super.statusCode});
}

class MaladhHeaderFetchFailure extends MaladhFailure {
  const MaladhHeaderFetchFailure({
    super.message = 'تعذر استرجاع بيانات سكينة والملاذ',
    super.statusCode,
  });
}

