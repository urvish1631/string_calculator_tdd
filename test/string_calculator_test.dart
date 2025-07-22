import 'package:flutter_test/flutter_test.dart';
import '../lib/string_calculator.dart';

void main() {
  group('StringCalculator – core', () {
    test('Empty string returns 0', () {
      expect(add(''), 0);
    });

    test('Single number', () {
      expect(add('5'), 5);
    });

    test('Multiple numbers simple', () {
      expect(add('1,2,3'), 6);
    });

    test('Mixed junk delimiters are ignored', () {
      expect(add('1,?2;3\$\$4'), 10);
    });

    test('Emoji delimiters', () {
      expect(add('🍎7🐍8'), 15);
    });
  });

  group('Newlines and mixed delimiters', () {
    test(r'Handles \n and commas', () {
      expect(add('1\n2,3'), 6);
    });

    test(r'Handles Windows line endings \r\n', () {
      expect(add('1\r\n2,3'), 6);
    });

    test('Custom delimiter header is ignored as noise (//;)', () {
      expect(add('//;\n1;?2'), 3); // ? ignored, digits parsed
    });

    test('Custom multi-delimiter header ignored', () {
      expect(add('//[;][%]\n1;2%3'), 6);
    });
  });

  group('Negatives', () {
    test('Single negative throws', () {
      expect(
        () => add('1,-2,3'),
        throwsA(predicate((e) => e.toString().contains('-2'))),
      );
    });

    test('Multiple negatives are all reported', () {
      expect(
        () => add('x-1y-2z-3'),
        throwsA(predicate((e) => e.toString().contains('[-1, -2, -3]'))),
      );
    });

    test('Negative with junk around', () {
      expect(
        () => add('abc-4??5'),
        throwsA(predicate((e) => e.toString().contains('-4'))),
      );
    });

    test('Negative > 1000 still triggers error', () {
      expect(
        () => add('2,-1005,3'),
        throwsA(predicate((e) => e.toString().contains('-1005'))),
      );
    });
  });

  group('>1000 ignore rule', () {
    test('1000 is included', () {
      expect(add('1000,1'), 1001);
    });

    test('1001 is ignored', () {
      expect(add('2,1001'), 2);
    });

    test('Mixed below/above', () {
      expect(add('999,1000,1001,1002,1'), 999 + 1000 + 1);
    });
  });

  group('No digits', () {
    test('Symbols only', () {
      expect(add('@@@###!!!'), 0);
    });

    test('Letters only', () {
      expect(add('abcXYZ'), 0);
    });

    test('Emoji only', () {
      expect(add('💥🔥🎉'), 0);
    });
  });


  group('Leading zeros & embedded digits', () {
    test('Leading zeros parsed', () {
      expect(add('0007'), 7);
    });

    test('Mixed leading zeros', () {
      expect(add('0007,0003'), 10);
    });

    test('Digits embedded in letters', () {
      expect(add('a12b3c004'), 12 + 3 + 4);
    });
  });

  group('Header digits edge behavior', () {
    test('Digits in header counted? (documented behavior)', () {
      expect(add('//123\n4'), 127);
    });
  });

  group('Idempotency / multiple runs', () {
    test('Calling add multiple times does not accumulate state', () {
      expect(add('1,2,3'), 6);
      expect(add('4,5'), 9);
      expect(add(''), 0);
    });
  });

  group('Stress', () {
    test('Large input string', () {

      final sb = StringBuffer();
      int expected = 0;
      for (int i = 1; i <= 500; i++) {
        expected += i;
        sb.write(i);
        sb.write(i.isEven ? '???' : ',,');
      }
      final input = sb.toString();
      expect(add(input), expected);
    });
  });
}
