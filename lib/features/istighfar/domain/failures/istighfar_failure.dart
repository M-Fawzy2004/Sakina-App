import 'package:sakina_app/core/errors/failures.dart';

/// Domain failures specific to the Istighfar and Digital Sibha feature.
class IstighfarStorageFailure extends Failure {
  const IstighfarStorageFailure({
    super.message = 'تعذر تحديث أو حفظ بيانات الاستغفار محلياً',
    super.statusCode,
  });
}

