import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/core/constants/app_constants.dart';

void main() {
  test('Sanity test for Sakina constants and configuration', () {
    expect(AppConstants.appName, 'سكينة');
    expect(AppConstants.appNameEnglish, 'Sakina');
  });
}
