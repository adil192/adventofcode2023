import 'dart:io';

import 'package:dart_numerics/dart_numerics.dart';

class DesertMap {
  factory DesertMap.fromInput(List<String> lines) {
    assert(RegExp(r'[RL]+').hasMatch(lines.first));
    final directions = lines.first
        .split('')
        .map((lr) => switch (lr) {
              'R' => Direction.right,
              'L' => Direction.left,
              _ => throw ArgumentError('Invalid direction: $lr'),
            })
        .toList(growable: false);

    final network = <String, (String left, String right)>{};
    for (final line in lines.skip(2)) {
      // line looks like "AAA = (BBB, CCC)"
      final [start, end] = line.split(' = ');
      final [left, right] = end.substring(1, end.length - 1).split(', ');
      network[start] = (left, right);
    }

    return DesertMap._(directions, network);
  }

  DesertMap._(this.directions, this.network);

  /// A series of left and right directions.
  ///
  /// Don't use this list directly, use [getDirection] instead.
  final List<Direction> directions;

  /// Maps a node to its left and right neighbors.
  final Map<String, (String left, String right)> network;

  /// Returns the direction at the given index.
  /// If the index is out of bounds, it will wrap around.
  Direction getDirection(int index) {
    return directions[index % directions.length];
  }

  /// Returns how many steps it takes to get from
  /// [startNode] to a node that satisfies [success].
  int _stepsFromStart(String startNode, bool Function(String) success) {
    var steps = 0;
    var currentNode = startNode;
    while (!success(currentNode)) {
      final direction = getDirection(steps);
      ++steps;
      final (left, right) = network[currentNode]!;
      currentNode = direction == Direction.left ? left : right;
    }
    return steps;
  }

  /// Returns how many steps it takes to get from
  /// AAA to ZZZ.
  int stepsFromAAAtoZZZ() => _stepsFromStart('AAA', (node) => node == 'ZZZ');

  /// Returns how many steps it takes to get from
  /// all nodes ending in A to all nodes ending in Z.
  int ghostStepsFromAsToZs() {
    final individualNodeSteps = network.keys
        .where((node) => node.endsWith('A'))
        .map((node) => _stepsFromStart(node, (node) => node.endsWith('Z')))
        .toList(growable: false);
    return leastCommonMultipleOfMany(individualNodeSteps);
  }
}

enum Direction { left, right }

Future<void> main() async {
  final input = await File('assets/day_8.txt').readAsLines();
  final map = DesertMap.fromInput(input);

  print('It takes ${map.stepsFromAAAtoZZZ()} steps to get from AAA to ZZZ.');

  print(
      'It takes ${map.ghostStepsFromAsToZs()} ghost steps to get from **A to **Z.');
}
