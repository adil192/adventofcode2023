import 'dart:io';

List<int> parseInput(String line) {
  return line.split(' ').map(int.parse).toList(growable: false);
}

int extrapolate(List<int> history) {
  /// deltas[0] is the original history list,
  /// deltas[1] is the difference between each element in deltas[0],
  /// deltas[2] is the difference between each element in deltas[1], etc.
  final deltas = <List<int>>[
    history,
  ];
  // Keep finding deltas until we find a list of all 0s.
  while (deltas.last.any((element) => element != 0)) {
    final last = deltas.last;
    final next = List.filled(last.length - 1, 0);
    for (var i = 0; i < last.length - 1; i++) {
      next[i] = last[i + 1] - last[i];
    }
    deltas.add(next);
  }

  // The extrapolated value is the sum of the last element in each delta list.
  return deltas.map((delta) => delta.last).reduce((a, b) => a + b);
}

Future<void> main() async {
  final input = await File('assets/day_9.txt')
      .readAsLines()
      .then((lines) => lines.map(parseInput).toList(growable: false));

  final extrapolated = input.map(extrapolate);
  final extrapolatedSum = extrapolated.reduce((a, b) => a + b);
  print('Sum of extrapolated values: $extrapolatedSum');
}
