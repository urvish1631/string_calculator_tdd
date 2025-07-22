import 'package:flutter_test/flutter_test.dart';
import '../lib/string_calculator.dart';

void main() {
  group('Advanced StringCalculator', () {
    test('Empty string returns 0', () {
      expect(add(''), 0);
    });

    test('Handles single and multiple numbers', () {
      expect(add('1,2,3'), 6);
      expect(add('5'), 5);
    });
  
    test('Throws error for negative numbers', () {
      expect(() => add('1,-2,3'),
          throwsA(predicate((e) => e.toString().contains('Negative numbers not allowed'))));
    });
  });
}
