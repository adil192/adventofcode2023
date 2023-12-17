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
