import 'package:adventofcode2023/week_1.dart';
import 'package:test/test.dart';

final _egLines = '''1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet'''
    .split('\n');

void main() {
  group('Week 1', () {
    test('getCalibrationValue', () {
      expect(getCalibrationValue(_egLines[0]), 12);
      expect(getCalibrationValue(_egLines[1]), 38);
      expect(getCalibrationValue(_egLines[2]), 15);
      expect(getCalibrationValue(_egLines[3]), 77);
    });
    test('isDigit', () {
      expect(isDigit('0'), true);
      expect(isDigit('9'), true);
      expect(isDigit('a'), false);
      expect(isDigit('z'), false);
      expect(isDigit('A'), false);
      expect(isDigit('Z'), false);
    });
  });
}
