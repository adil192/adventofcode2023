class Pipes {
  factory Pipes.fromInput(Iterable<String> lines) {
    final pipes = <List<Pipe>>[];
    late final (int row, int col) startIndex;
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
  final (int row, int col) startIndex;
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
