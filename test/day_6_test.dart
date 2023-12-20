import 'package:adventofcode2023/day_6.dart';
import 'package:test/test.dart';

const _egInput = '''Time:      7  15   30
Distance:  9  40  200''';

void main() {
  group('Day 6', () {
    late final List<Record> records;
    setUpAll(() {
      records = Record.fromFile(_egInput).toList();
    });

    test('Record.fromFile', () {
      expect(records.length, 3);
      expect(records[0].msLimit, 7);
      expect(records[0].recordDistance, 9);
      expect(records[1].msLimit, 15);
      expect(records[1].recordDistance, 40);
      expect(records[2].msLimit, 30);
      expect(records[2].recordDistance, 200);
    });

    test('Record.distanceWhenHeldDown', () {
      expect(records[0].distanceWhenHeldDown(0), 0);
      expect(records[0].distanceWhenHeldDown(1), 6);
      expect(records[0].distanceWhenHeldDown(2), 10);
      expect(records[0].distanceWhenHeldDown(3), 12);
      expect(records[0].distanceWhenHeldDown(4), 12);
      expect(records[0].distanceWhenHeldDown(5), 10);
      expect(records[0].distanceWhenHeldDown(6), 6);
      expect(records[0].distanceWhenHeldDown(7), 0);
    });

    test('Record.waysToWin', () {
      expect(records[0].waysToWin(), 4);
      expect(records[1].waysToWin(), 8);
      expect(records[2].waysToWin(), 9);
      expect(records.waysToWinProduct(), 4 * 8 * 9);
    });
  });
}
