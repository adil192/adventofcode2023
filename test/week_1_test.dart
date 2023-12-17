import 'package:adventofcode2023/week_1.dart';
import 'package:test/test.dart';

final _egLines = '''1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
xyzone23456seven'''
    .split('\n');

void main() {
  group('Week 1', () {
    test('getNumberAtPos', () {
      expect(getNumberAtPos(_egLines[0], 0), 1);
      expect(getNumberAtPos(_egLines[0], 1), null);
      expect(getNumberAtPos(_egLines[4], 3), 1);
      expect(getNumberAtPos(_egLines[4], 4), null);
      expect(getNumberAtPos(_egLines[4], 6), 2);
      expect(getNumberAtPos(_egLines[4], 11), 7);
    });
    test('getCalibrationValue', () {
      expect(getCalibrationValue(_egLines[0]), 12);
      expect(getCalibrationValue(_egLines[1]), 38);
      expect(getCalibrationValue(_egLines[2]), 15);
      expect(getCalibrationValue(_egLines[3]), 77);
      expect(getCalibrationValue(_egLines[4]), 17);
    });
  });
}
