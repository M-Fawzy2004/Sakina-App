import 'package:fpdart/fpdart.dart';
import 'package:sakina_app/core/errors/failures.dart';
import 'package:sakina_app/features/athkar/data/datasources/athkar_local_data_source.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_category_entity.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_item_entity.dart';
import 'package:sakina_app/features/athkar/domain/failures/athkar_failure.dart';
import 'package:sakina_app/features/athkar/domain/repositories/athkar_repository.dart';

/// Implementation of AthkarRepository connecting data sources to domain.
class AthkarRepositoryImpl implements AthkarRepository {
  final AthkarLocalDataSource localDataSource;

  const AthkarRepositoryImpl({required this.localDataSource});

  static const Map<String, ({String desc, String icon})> _kCategoryMeta = {
    'أذكار الصباح': (desc: 'نور الصباح وحصن المسلم ليومه', icon: 'morning'),
    'أذكار المساء': (desc: 'سكينة المساء وحفظ من كل سوء', icon: 'evening'),
    'تسابيح': (desc: 'تسبيح، تحميد، واستغفار مبارك', icon: 'tasbih'),
    'أذكار النوم': (desc: 'أوراد السكينة والطمأنينة قبل النوم', icon: 'sleep'),
    'أذكار بعد السلام من الصلاة المفروضة': (
      desc: 'سنن وأوراد مباركة دبر كل فريضة',
      icon: 'prayer'
    ),
    'أذكار الاستيقاظ': (
      desc: 'شكر الله وحمده على إحياء النفوس',
      icon: 'waking'
    ),
    'أدعية قرآنية': (
      desc: 'جامع الأدعية المأثورة من القرآن الكريم',
      icon: 'quran'
    ),
    'أدعية الأنبياء': (
      desc: 'مناجاة ودعاء الأنبياء والمرسلين',
      icon: 'prophets'
    ),
  };

  @override
  Future<Either<Failure, List<AthkarCategoryEntity>>> getCategories() async {
    try {
      final all = await localDataSource.loadAllAthkar();
      final List<AthkarCategoryEntity> categories = [];

      final preferredOrder = [
        'أذكار الصباح',
        'أذكار المساء',
        'تسابيح',
        'أذكار النوم',
        'أذكار بعد السلام من الصلاة المفروضة',
        'أدعية قرآنية',
        'أدعية الأنبياء',
        'أذكار الاستيقاظ',
      ];

      for (final catName in preferredOrder) {
        if (all.containsKey(catName)) {
          final items = all[catName]!;
          final meta = _kCategoryMeta[catName] ??
              (desc: 'أوراد نبوية مباركة', icon: 'tasbih');
          categories.add(
            AthkarCategoryEntity(
              name: catName,
              count: items.length,
              description: meta.desc,
              iconKey: meta.icon,
            ),
          );
        }
      }

      for (final entry in all.entries) {
        if (!preferredOrder.contains(entry.key)) {
          categories.add(
            AthkarCategoryEntity(
              name: entry.key,
              count: entry.value.length,
              description: 'أذكار وأدعية مباركة',
              iconKey: 'tasbih',
            ),
          );
        }
      }

      return Right(categories);
    } catch (e) {
      return Left(AthkarFailure(message: 'فشل تحميل بيانات الأذكار: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AthkarItemEntity>>> getAthkarByCategory(
      String category) async {
    try {
      final items = await localDataSource.getAthkarByCategory(category);
      return Right(items);
    } catch (e) {
      return Left(AthkarFailure(message: 'فشل تحميل أذكار $category: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, List<AthkarItemEntity>>>> getAllAthkar() async {
    try {
      final all = await localDataSource.loadAllAthkar();
      return Right(all);
    } catch (e) {
      return Left(AthkarFailure(message: 'فشل تحميل الأذكار: $e'));
    }
  }
}

