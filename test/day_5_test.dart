import 'package:adventofcode2023/day_5.dart';
import 'package:test/test.dart';

void main() {
  group('Day 5', () {
    late final Almanac almanac;
    setUpAll(() {
      almanac = Almanac.fromFile(_egInput.split('\n'));
    });
    test('Parse input', () {
      expect(almanac.seeds, [79, 14, 55, 13]);
      expect(almanac.maps.keys, [
        'seed',
        'soil',
        'fertilizer',
        'water',
        'light',
        'temperature',
        'humidity',
      ]);
      final seedToSoilMap = almanac.maps['seed']!;
      expect(seedToSoilMap.categoryFrom, 'seed');
      expect(seedToSoilMap.categoryTo, 'soil');
      expect(seedToSoilMap.mapParts, [
        AlmanacMapPart(50, 98, 2),
        AlmanacMapPart(52, 50, 48),
      ]);
    });
    test('Map seeds to locations', () {
      expect(almanac.convertSeedToLocation(79), 82);
      expect(almanac.convertSeedToLocation(14), 43);
      expect(almanac.convertSeedToLocation(55), 86);
      expect(almanac.convertSeedToLocation(13), 35);
    });
  });
}

const _egInput = '''seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4''';
