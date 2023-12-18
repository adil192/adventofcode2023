import 'package:adventofcode2023/day_3.dart';
import 'package:test/test.dart';

const _egSchematic = r'''467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..''';

void main() {
  group('Day 3', () {
    test('getPartNumbers', () {
      expect(
        getPartNumbers(_egSchematic),
        <Coord, int>{
          (0, 0): 467,
          (2, 2): 35,
          (6, 2): 633,
          (0, 4): 617,
          (2, 6): 592,
          (6, 7): 755,
          (1, 9): 664,
          (5, 9): 598
        },
      );
    });
  });
}
