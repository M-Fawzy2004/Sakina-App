import 'package:sakina_app/core/errors/failures.dart';

/// Domain failures originating from Quran catalog and reader operations.
class QuranDataFetchFailure extends Failure {
  const QuranDataFetchFailure({
    super.message = 'تعذر تحميل بيانات المصحف الشريف، يرجى المحاولة لاحقاً',
    super.statusCode,
  });
}

class QuranBookmarkFailure extends Failure {
  const QuranBookmarkFailure({
    super.message = 'تعذر حفظ أو استرجاع موضع القراءة',
    super.statusCode,
  });
}

