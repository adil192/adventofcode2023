import 'package:adventofcode2023/day_2.dart';
import 'package:test/test.dart';

final _egInput = '''Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green''';

void main() {
  group('Day 2', () {
    late final Map<int, List<Round>> games;
    setUpAll(() {
      games = parseInput(_egInput.split('\n'));
    });

    test('parseInput', () {
      expect(games.keys, [1, 2, 3, 4, 5]);
      expect(games[1]![0], (r: 4, g: 0, b: 3));
      expect(games[1]![1], (r: 1, g: 2, b: 6));
      expect(games[1]![2], (r: 0, g: 2, b: 0));
    });

    test('possibleGames (12,13,14)', () {
      final possibles = possibleGames(games, (r: 12, g: 13, b: 14));
      expect(possibles, [1, 2, 5]);
    });

    test('minPossibleCubes', () {
      expect(minPossibleCubes(games[1]!), (r: 4, g: 2, b: 6));
      expect(minPossibleCubes(games[2]!), (r: 1, g: 3, b: 4));
      expect(minPossibleCubes(games[3]!), (r: 20, g: 13, b: 6));
      expect(minPossibleCubes(games[4]!), (r: 14, g: 3, b: 15));
      expect(minPossibleCubes(games[5]!), (r: 6, g: 3, b: 2));
    });
  });
}
