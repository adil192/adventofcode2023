import 'dart:io';
import 'dart:math';

/// Holds the count of [r] red cubes, [g] green cubes, and [b] blue cubes.
///
/// There are "a few" rounds per game (3?).
typedef Round = ({int r, int g, int b});

Map<int, List<Round>> parseInput(List<String> lines) {
  final games = <int, List<Round>>{};
  for (final line in lines) {
    final (id, game) = _parseLine(line);
    games[id] = game;
  }
  return games;
}

(int, List<Round>) _parseLine(String line) {
  /// The line starts with 'Game 123: ...'
  final gameNumber = int.parse(line.substring(
    'Game '.length,
    line.indexOf(':'),
  ));
  final rounds = line.substring(line.indexOf(':') + 2).split('; ');
  final parsedRounds = rounds.map(_parseRound).toList();
  return (gameNumber, parsedRounds);
}

/// [input] is a string like `1 red, 2 green, 6 blue`.
Round _parseRound(String input) {
  /// e.g. ['1', 'red,', '2', 'green,', '6', 'blue']
  final tokens = input.split(' ');
  int lastNumber = 0;
  int r = 0, g = 0, b = 0;
  for (final token in tokens) {
    if (token == 'red,' || token == 'red') {
      r = lastNumber;
    } else if (token == 'green,' || token == 'green') {
      g = lastNumber;
    } else if (token == 'blue,' || token == 'blue') {
      b = lastNumber;
    } else {
      lastNumber = int.parse(token);
    }
  }
  return (r: r, g: g, b: b);
}

/// Returns the IDs of the games that would have been possible
/// given the cubes in [maxPerRound].
List<int> possibleGames(Map<int, List<Round>> games, Round maxPerRound) {
  final possible = <int>[];
  for (final MapEntry(key: id, value: rounds) in games.entries) {
    if (possibleGame(rounds, maxPerRound)) {
      possible.add(id);
    }
  }
  return possible;
}

/// Returns true if [rounds] could be played with [maxPerRound].
bool possibleGame(List<Round> rounds, Round maxPerRound) =>
    rounds.every((round) =>
        round.r <= maxPerRound.r &&
        round.g <= maxPerRound.g &&
        round.b <= maxPerRound.b);

/// (Part 2) Gets the fewest number of red, green, and blue cubes
/// that could have been in the bag for [rounds] to be possible.
Round minPossibleCubes(List<Round> rounds) => (
      r: rounds.map((round) => round.r).reduce(max),
      g: rounds.map((round) => round.g).reduce(max),
      b: rounds.map((round) => round.b).reduce(max),
    );

/// (Part 2) Gets the power of a round,
/// which is the product of the number of cubes of each color.
int powerOfRound(Round round) => round.r * round.g * round.b;

/// Returns the sum of the IDs of the games that would have been possible
/// if the bag had been loaded with only 12 red cubes, 13 green cubes,
/// and 14 blue cubes.
Future<void> main() async {
  const maxPerRound = (r: 12, g: 13, b: 14);
  final lines = await File('assets/day_2.txt').readAsLines();
  final games = parseInput(lines);

  final possibleIds = possibleGames(games, maxPerRound);
  final sumPossibleIds = possibleIds.reduce((a, b) => a + b);
  print('The sum of the IDs of the possible games is $sumPossibleIds');

  final roundPowers = games.values.map(minPossibleCubes).map(powerOfRound);
  final sumRoundPowers = roundPowers.reduce((a, b) => a + b);
  print('The sum of the powers of the minimum set of cubes is $sumRoundPowers');
}
