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

void main() {
  group('Day 8', () {
    late final DesertMap map1;
    late final DesertMap map2;
    setUpAll(() {
      map1 = DesertMap.fromInput(_egInput1.split('\n'));
      map2 = DesertMap.fromInput(_egInput2.split('\n'));
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

    test('stepsFromAAAtoZZZ', () {
      expect(map1.stepsFromAAAtoZZZ(), 2);
      expect(map2.stepsFromAAAtoZZZ(), 6);
    });
  });
}
