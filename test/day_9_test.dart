import 'package:adventofcode2023/day_9.dart';
import 'package:test/test.dart';

const _egInput = '''0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45''';

void main() {
  group('Day 9', () {
    late final List<List<int>> input;
    setUpAll(() {
      input = _egInput.split('\n').map(parseInput).toList(growable: false);
    });

    test('parseInput', () {
      expect(input[0], [0, 3, 6, 9, 12, 15]);
      expect(input[1], [1, 3, 6, 10, 15, 21]);
      expect(input[2], [10, 13, 16, 21, 30, 45]);
    });

    test('extrapolate', () {
      expect(extrapolate(input[0]), 18);
      expect(extrapolate(input[1]), 28);
      expect(extrapolate(input[2]), 68);
    });
  });
}
