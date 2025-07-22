import 'package:flutter_test/flutter_test.dart';
import '../lib/string_calculator.dart';

void main() {
  group('Advanced StringCalculator', () {
    test('Empty string returns 0', () {
      expect(add(''), 0);
    });
  });
}
