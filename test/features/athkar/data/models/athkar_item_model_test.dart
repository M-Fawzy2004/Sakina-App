import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/features/athkar/data/models/athkar_item_model.dart';
import 'package:sakina_app/features/athkar/domain/entities/athkar_item_entity.dart';

void main() {
  group('AthkarItemModel Tests', () {
    const testJson = {
      'category': 'أذكار الصباح',
      'count': '3',
      'description': 'من قالها حين يصبح كان حقاً على الله أن يرضيه',
      'reference': 'رواه الترمذي',
      'content': 'رَضيـتُ بِاللهِ رَبَّـاً وَبِالإسْلامِ ديـناً',
    };

    test('should parse correctly from valid JSON with string count', () {
      final model = AthkarItemModel.fromJson(testJson);

      expect(model.category, 'أذكار الصباح');
      expect(model.count, 3);
      expect(model.description, 'من قالها حين يصبح كان حقاً على الله أن يرضيه');
      expect(model.reference, 'رواه الترمذي');
      expect(model.content, 'رَضيـتُ بِاللهِ رَبَّـاً وَبِالإسْلامِ ديـناً');
      expect(model, isA<AthkarItemEntity>());
    });

    test('should handle int count correctly in fromJson', () {
      final jsonWithInt = {
        'category': 'تسابيح',
        'count': 33,
        'description': '',
        'reference': '',
        'content': 'سُبْحَانَ اللَّهِ',
      };

      final model = AthkarItemModel.fromJson(jsonWithInt);
      expect(model.count, 33);
    });

    test('should serialize to valid JSON', () {
      final model = AthkarItemModel.fromJson(testJson);
      final json = model.toJson();

      expect(json['category'], 'أذكار الصباح');
      expect(json['count'], '3');
      expect(json['content'], 'رَضيـتُ بِاللهِ رَبَّـاً وَبِالإسْلامِ ديـناً');
    });
  });
}

