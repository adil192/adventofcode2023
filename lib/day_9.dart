import 'dart:io';

List<int> parseInput(String line) {
  return line.split(' ').map(int.parse).toList(growable: false);
}

/// deltas[0] is the original history list,
/// deltas[1] is the difference between each element in deltas[0],
/// deltas[2] is the difference between each element in deltas[1], etc.
List<List<int>> findDeltas(List<int> history) {
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
  return deltas;
}

int extrapolateNext(List<int> history) {
  final deltas = findDeltas(history);
  return deltas.fold(0, (sum, delta) => delta.last + sum);
}

// TODO(adil192): This passes the tests, but gives the wrong answer.
int extrapolatePrev(List<int> history) {
  final deltas = findDeltas(history);
  return deltas.fold(0, (sum, delta) => delta.first - sum);
}

Future<void> main() async {
  final input = await File('assets/day_9.txt')
      .readAsLines()
      .then((lines) => lines.map(parseInput).toList(growable: false));

  final nexts = input.map(extrapolateNext);
  final sumOfNexts = nexts.reduce((a, b) => a + b);
  print('Sum of next values: $sumOfNexts');

  final prevs = input.map(extrapolatePrev);
  final sumOfPrevs = prevs.reduce((a, b) => a + b);
  print('Sum of prev values: $sumOfPrevs');
}
