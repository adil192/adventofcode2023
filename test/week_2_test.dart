import 'package:adventofcode2023/week_2.dart';
import 'package:test/test.dart';

final _egLine = 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green';

void main() {
  group('Week 2', () {
    test('parseInput', () {
      final games = parseInput([_egLine]);
      expect(games.keys, [1]);
      expect(games[1]![0], (r: 4, g: 0, b: 3));
      expect(games[1]![1], (r: 1, g: 2, b: 6));
      expect(games[1]![2], (r: 0, g: 2, b: 0));
    });
  });
}
