import 'package:flutter_test/flutter_test.dart';
import 'package:sakina_app/core/utils/url_launcher_helper.dart';

void main() {
  group('UrlLauncherHelper Tests', () {
    test('privacyPolicyUrl matches the official GitHub Pages URL', () {
      expect(
        UrlLauncherHelper.privacyPolicyUrl,
        'https://m-fawzy2004.github.io/sakina_privacy_policy/',
      );
    });

    test('privacyPolicyUrl is a valid HTTPS URI', () {
      final uri = Uri.parse(UrlLauncherHelper.privacyPolicyUrl);
      expect(uri.scheme, 'https');
      expect(uri.host, 'm-fawzy2004.github.io');
      expect(uri.path, '/sakina_privacy_policy/');
    });
  });
}

