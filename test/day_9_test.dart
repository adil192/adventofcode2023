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

    test('extrapolateNext', () {
      expect(extrapolateNext(input[0]), 18);
      expect(extrapolateNext(input[1]), 28);
      expect(extrapolateNext(input[2]), 68);
    });

    test('extrapolatePrev', () {
      expect(extrapolatePrev(input[0]), -3);
      expect(extrapolatePrev(input[1]), 0);
      expect(extrapolatePrev(input[2]), 5);
    });
  });
}
