import 'package:adventofcode2023/day_8.dart';
import 'package:test/test.dart';

const _egInput1 = '''RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)''';

const _egInput2 = '''LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)''';

const _egInput3 = '''LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)''';

void main() {
  group('Day 8', () {
    late final DesertMap map1;
    late final DesertMap map2;
    late final DesertMap map3;
    setUpAll(() {
      map1 = DesertMap.fromInput(_egInput1.split('\n'));
      map2 = DesertMap.fromInput(_egInput2.split('\n'));
      map3 = DesertMap.fromInput(_egInput3.split('\n'));
    });

    test('DesertMap.fromInput (1)', () {
      expect(map1.directions, [Direction.right, Direction.left]);
      expect(map1.network, {
        'AAA': ('BBB', 'CCC'),
        'BBB': ('DDD', 'EEE'),
        'CCC': ('ZZZ', 'GGG'),
        'DDD': ('DDD', 'DDD'),
        'EEE': ('EEE', 'EEE'),
        'GGG': ('GGG', 'GGG'),
        'ZZZ': ('ZZZ', 'ZZZ'),
      });
    });

    test('DesertMap.fromInput (2)', () {
      expect(
          map2.directions, [Direction.left, Direction.left, Direction.right]);
      expect(map2.network, {
        'AAA': ('BBB', 'BBB'),
        'BBB': ('AAA', 'ZZZ'),
        'ZZZ': ('ZZZ', 'ZZZ'),
      });
    });

    test('DesertMap.fromInput (3)', () {
      expect(map3.directions, [Direction.left, Direction.right]);
      expect(map3.network, {
        '11A': ('11B', 'XXX'),
        '11B': ('XXX', '11Z'),
        '11Z': ('11B', 'XXX'),
        '22A': ('22B', 'XXX'),
        '22B': ('22C', '22C'),
        '22C': ('22Z', '22Z'),
        '22Z': ('22B', '22B'),
        'XXX': ('XXX', 'XXX'),
      });
    });

    test('stepsFromAAAtoZZZ', () {
      expect(map1.stepsFromAAAtoZZZ(), 2);
      expect(map2.stepsFromAAAtoZZZ(), 6);
    });

    test('ghostStepsFromAToZ', () {
      expect(map3.ghostStepsFromAsToZs(), 6);
    });
  });
}
