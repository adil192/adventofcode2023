import 'dart:io';
import 'dart:math';

class Almanac {
  factory Almanac.fromFile(List<String> lines) {
    final firstLine = lines.first;
    assert(firstLine.startsWith('seeds: '));
    final seeds = firstLine
        .substring('seeds: '.length)
        .split(' ')
        .map(int.parse)
        .toList();
    final maps = <String, AlmanacMap>{};
    final currentMapLines = <String>[];
    for (final line in lines.skip(2)) {
      if (line.isEmpty) {
        final map = AlmanacMap.fromLines(currentMapLines);
        maps[map.categoryFrom] = map;
        currentMapLines.clear();
      } else {
        currentMapLines.add(line);
      }
    }
    if (currentMapLines.isNotEmpty) {
      final map = AlmanacMap.fromLines(currentMapLines);
      maps[map.categoryFrom] = map;
    }
    return Almanac._(seeds, maps);
  }

  const Almanac._(this.seeds, this.maps);

  /// The seeds that need to be planted
  final List<int> seeds;

  /// The list of maps from one category to another,
  /// indexed by the category from.
  final Map<String, AlmanacMap> maps;

  /// Convert a seed number to a location number.
  int convertSeedToLocation(int seed) {
    String category = 'seed';
    int location = seed;
    while (category != 'location') {
      final map = maps[category];
      assert(map != null, 'No map for $category');
      location = map!.convert(location);
      category = map.categoryTo;
    }
    return location;
  }
}

/// A map from [categoryFrom] to [categoryTo].
class AlmanacMap {
  factory AlmanacMap.fromLines(List<String> lines) {
    /// First line looks like "seed-to-soil map:"
    final firstLine = lines.first;
    assert(firstLine.endsWith(' map:'));
    final [categoryFrom, categoryTo] =
        firstLine.substring(0, firstLine.length - ' map:'.length).split('-to-');
    final mapParts = lines.skip(1).map(AlmanacMapPart.fromLine).toList();
    return AlmanacMap._(categoryFrom, categoryTo, mapParts);
  }

  const AlmanacMap._(this.categoryFrom, this.categoryTo, this.mapParts);

  final String categoryFrom;
  final String categoryTo;
  final List<AlmanacMapPart> mapParts;

  /// Convert [source] from [categoryFrom] to [categoryTo].
  int convert(int source) {
    for (final mapPart in mapParts) {
      if (source < mapPart.sourceStart) continue;
      if (source >= mapPart.sourceStart + mapPart.rangeLength) continue;
      return mapPart.destinationStart + (source - mapPart.sourceStart);
    }
    // If not explicitly mapped, return the source number.
    return source;
  }
}

/// Rather than list every source number and its corresponding destination
/// number one by one, the maps describe entire ranges of numbers that can
/// be converted.
///
/// Each [AlmanacMapPart] within a [AlmanacMap] contains three numbers:
/// the destination range start,
/// the source range start,
/// and the range length.
class AlmanacMapPart {
  factory AlmanacMapPart.fromLine(String line) {
    final parts = line.split(' ');
    assert(parts.length == 3);
    final destinationStart = int.parse(parts[0]);
    final sourceStart = int.parse(parts[1]);
    final rangeLength = int.parse(parts[2]);
    return AlmanacMapPart(destinationStart, sourceStart, rangeLength);
  }

  const AlmanacMapPart(
      this.destinationStart, this.sourceStart, this.rangeLength);

  final int destinationStart;
  final int sourceStart;
  final int rangeLength;

  @override
  bool operator ==(Object other) =>
      other is AlmanacMapPart &&
      destinationStart == other.destinationStart &&
      sourceStart == other.sourceStart &&
      rangeLength == other.rangeLength;
  @override
  int get hashCode =>
      destinationStart.hashCode ^ sourceStart.hashCode ^ rangeLength.hashCode;
  @override
  String toString() =>
      'AlmanacMapPart($destinationStart, $sourceStart, $rangeLength)';
}

Future<void> main() async {
  final input = await File('assets/day_5.txt').readAsString();
  final almanac = Almanac.fromFile(input.split('\n'));

  final seedLocations = almanac.seeds.map(almanac.convertSeedToLocation);
  final smallestLocation = seedLocations.reduce(min);
  print('(Part 1) Smallest location: $smallestLocation');
}
