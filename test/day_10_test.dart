import 'package:adventofcode2023/day_10.dart';
import 'package:test/test.dart';

const _egInput1Clean = '''.....
.S-7.
.|.|.
.L-J.
.....''';
const _egInput1Cluttered = '''-L|F7
7S-7|
L|7||
-L-J|
L|-JF''';
const _egInput2Clean = '''..F7.
.FJ|.
SJ.L7
|F--J
LJ...''';
const _egInput2Cluttered = '''7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ''';

void main() {
  group('Day 10', () {
    late final Pipes pipes1Clean, pipes1Cluttered, pipes2Clean, pipes2Cluttered;
    setUpAll(() {
      pipes1Clean = Pipes.fromInput(_egInput1Clean.split('\n'));
      pipes1Cluttered = Pipes.fromInput(_egInput1Cluttered.split('\n'));
      pipes2Clean = Pipes.fromInput(_egInput2Clean.split('\n'));
      pipes2Cluttered = Pipes.fromInput(_egInput2Cluttered.split('\n'));
    });
    test('Pipes.fromInput', () {
      expect(pipes1Clean.pipes.length, 5);
      expect(pipes1Clean.pipes[0].length, 5);
      expect(pipes1Clean.pipes[0][0], Pipe.ground);
      expect(pipes1Clean.pipes[1][1], Pipe.start);
      expect(pipes1Clean.startIndex, (1, 1));

      expect(pipes2Cluttered.pipes.length, 5);
      expect(pipes2Cluttered.pipes[0].length, 5);
      expect(pipes2Cluttered.pipes[0][0], Pipe.sw);
      expect(pipes2Cluttered.pipes[2][0], Pipe.start);
      expect(pipes2Cluttered.startIndex, (2, 0));
    });
  });
}
