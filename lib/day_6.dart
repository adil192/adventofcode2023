import 'dart:io';

class Record {
  const Record(this.msLimit, this.recordDistance);

  /// (Part 1)
  /// Parses multiple records that are separated by spaces.
  static Iterable<Record> fromFileMultiple(String input) sync* {
    var [timeLine, distanceLine] = input.split('\n');

    assert(timeLine.startsWith('Time:'));
    assert(distanceLine.startsWith('Distance:'));
    timeLine = timeLine.substring('Time:'.length).trim();
    distanceLine = distanceLine.substring('Distance:'.length).trim();

    final whitespace = RegExp(r'\s+');
    final times = timeLine.split(whitespace).map(int.parse).toList();
    final distances = distanceLine.split(whitespace).map(int.parse).toList();

    assert(times.length == distances.length);
    for (var i = 0; i < times.length; i++) {
      yield Record(times[i], distances[i]);
    }
  }

  /// (Part 2)
  /// Parses one race, disregarding the spaces between digits.
  static Record fromFileSingle(String input) {
    var [timeLine, distanceLine] = input.split('\n');

    final whitespace = RegExp(r'\s+');
    assert(timeLine.startsWith('Time:'));
    assert(distanceLine.startsWith('Distance:'));
    timeLine = timeLine.substring('Time:'.length).replaceAll(whitespace, '');
    distanceLine =
        distanceLine.substring('Distance:'.length).replaceAll(whitespace, '');

    return Record(int.parse(timeLine), int.parse(distanceLine));
  }

  final int msLimit;
  final int recordDistance;

  int waysToWin() {
    int waysToWin = 0;
    for (int msHeldDown = 1; msHeldDown < msLimit; msHeldDown++) {
      if (distanceWhenHeldDown(msHeldDown) > recordDistance) {
        waysToWin++;
      }
    }
    return waysToWin;
  }

  int distanceWhenHeldDown(int msHeldDown) {
    assert(msHeldDown >= 0);
    assert(msHeldDown <= msLimit);
    final speed = msHeldDown;
    final timeLeft = msLimit - msHeldDown;
    return speed * timeLeft;
  }
}

extension RecordList on List<Record> {
  int waysToWinProduct() =>
      fold(1, (ways, record) => ways * record.waysToWin());
}

Future<void> main() async {
  final input = await File('assets/day_6.txt').readAsString();
  final records = Record.fromFileMultiple(input).toList();
  final singleRecord = Record.fromFileSingle(input);

  print('Part 1: ${records.waysToWinProduct()}');
  print('Part 2: ${singleRecord.waysToWin()}');
}
