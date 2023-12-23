typedef Pos = (int row, int col);

class Pipes {
  factory Pipes.fromInput(Iterable<String> lines) {
    final pipes = <List<Pipe>>[];
    late final Pos startIndex;
    for (final line in lines) {
      final row = <Pipe>[];
      pipes.add(row);
      for (final char in line.split('')) {
        switch (char) {
          case '|':
            row.add(Pipe.ns);
          case '-':
            row.add(Pipe.ew);
          case 'L':
            row.add(Pipe.ne);
          case 'J':
            row.add(Pipe.nw);
          case 'F':
            row.add(Pipe.se);
          case '7':
            row.add(Pipe.sw);
          case '.':
            row.add(Pipe.ground);
          case 'S':
            row.add(Pipe.start);
            startIndex = (pipes.length - 1, row.length - 1);
          default:
            throw ArgumentError.value(char, 'char', 'Invalid pipe type');
        }
      }
    }
    return Pipes._(pipes, startIndex);
  }
  Pipes._(this.pipes, this.startIndex);

  final List<List<Pipe>> pipes;
  final Pos startIndex;

  Pipe getPipe(Pos pos) => pipes[pos.$1][pos.$2];

  bool invalidPos(Pos pos) =>
      pos.$1 < 0 ||
      pos.$1 >= pipes.length ||
      pos.$2 < 0 ||
      pos.$2 >= pipes[pos.$1].length;

  List<Pos> findMainLoop() {
    /// The nodes directly connected to the start node,
    /// along with the direction of the previous pipe.
    final visited = <(Direction dirIn, Pos pos)>[
      (Direction.north, startIndex),
    ];

    /// The nodes that may be connected to the start node,
    /// but their pipe shape and neighbors are unknown,
    /// along with the direction of the previous pipe.
    final toVisit = <(Direction dirIn, Pos pos)>[
      (Direction.north, (startIndex.$1 - 1, startIndex.$2)),
      (Direction.east, (startIndex.$1, startIndex.$2 + 1)),
      (Direction.south, (startIndex.$1 + 1, startIndex.$2)),
      (Direction.west, (startIndex.$1, startIndex.$2 - 1)),
    ]
      ..removeWhere((nodes) => invalidPos(nodes.$2))
      ..removeWhere((nodes) => getPipe(nodes.$2) == Pipe.ground)
      ..removeWhere((nodes) {
        /// Remove nodes adjacent to the start node that are not connected to it.
        final (dirIn, pos) = nodes;
        final pipe = getPipe(pos);
        return switch (pipe) {
          Pipe.ns => dirIn == Direction.east || dirIn == Direction.west,
          Pipe.ew => dirIn == Direction.north || dirIn == Direction.south,
          Pipe.ne => dirIn == Direction.north || dirIn == Direction.east,
          Pipe.nw => dirIn == Direction.north || dirIn == Direction.west,
          Pipe.se => dirIn == Direction.south || dirIn == Direction.east,
          Pipe.sw => dirIn == Direction.south || dirIn == Direction.west,
          Pipe.start || Pipe.ground => throw StateError(
              'Start/ground node cannot be adjacent to start node'),
        };
      });
    assert(toVisit.isNotEmpty, 'Start node has no neighbours');

    while (toVisit.isNotEmpty) {
      final (dirIn, pos) = toVisit.removeLast();
      visited.add((dirIn, pos));
      final pipe = getPipe(pos);

      final dirOut = switch (pipe) {
        Pipe.ns => dirIn == Direction.north ? Direction.north : Direction.south,
        Pipe.ew => dirIn == Direction.east ? Direction.east : Direction.west,
        Pipe.ne => dirIn == Direction.south ? Direction.east : Direction.north,
        Pipe.nw => dirIn == Direction.south ? Direction.west : Direction.north,
        Pipe.se => dirIn == Direction.north ? Direction.east : Direction.south,
        Pipe.sw => dirIn == Direction.north ? Direction.west : Direction.south,
        Pipe.start || Pipe.ground => throw StateError(
            'Start/ground node should have been handled earlier'),
      };
      final nextPos = switch (dirOut) {
        Direction.north => (pos.$1 - 1, pos.$2),
        Direction.east => (pos.$1, pos.$2 + 1),
        Direction.south => (pos.$1 + 1, pos.$2),
        Direction.west => (pos.$1, pos.$2 - 1),
      };
      if (invalidPos(nextPos)) continue;

      final nextPipe = getPipe(nextPos);
      switch (nextPipe) {
        case Pipe.start:
          // We found the start node again, so we have found a loop.
          toVisit.clear();
        case Pipe.ground:
          // Ignore nodes with no pipe.
          break;
        default:
          toVisit.add((dirOut, nextPos));
      }
    }

    // Trace the loop back to the start node.
    // It doesn't matter which direction we go.
    final loop = <Pos>[startIndex];
    var (dirIn, pos) = visited.last;
    while (pos != startIndex) {
      loop.add(pos);
      final prevPos = switch (dirIn) {
        Direction.north => (pos.$1 + 1, pos.$2),
        Direction.east => (pos.$1, pos.$2 - 1),
        Direction.south => (pos.$1 - 1, pos.$2),
        Direction.west => (pos.$1, pos.$2 + 1),
      };
      (dirIn, pos) = visited.lastWhere((node) => node.$2 == prevPos);
    }
    return loop;
  }
}

enum Pipe {
  /// `|` is a vertical pipe connecting north and south.
  ns,

  /// `-` is a horizontal pipe connecting east and west.
  ew,

  /// `L` is a 90-degree bend connecting north and east.
  ne,

  /// `J` is a 90-degree bend connecting north and west.
  nw,

  /// `F` is a 90-degree bend connecting south and east.
  se,

  /// `7` is a 90-degree bend connecting south and west.
  sw,

  /// `.` is ground; there is no pipe in this tile.
  ground,

  /// `S` is the starting position of the animal; there is a pipe on this
  /// tile, but your sketch doesn't show what shape the pipe has.
  start,
}

enum Direction {
  north,
  east,
  south,
  west,
}
