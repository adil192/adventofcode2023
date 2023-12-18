import 'dart:io';
import 'dart:math';

/// The coordinate of a number/symbol in the input file,
/// where [y] is the line number and [x] is the character number.
typedef Coord = (int x, int y);

/// Returns the part numbers in the [schematic].
///
/// Any number adjacent to a symbol, even diagonally, is a "part number".
/// (Periods (.) do not count as a symbol.)
///
/// This functions assumes that each character in [schematic]
/// is either a number, a symbol, or a period.
Map<Coord, int> getPartNumbers(String schematic) {
  final partNumbers = <Coord, int>{};

  final lines = schematic.split('\n');
  for (int y = 0; y < lines.length; ++y) {
    for (int x = 0; x < lines[y].length; ++x) {
      final char = lines[y][x];
      if (!isDigit(char)) continue;

      // We've found a digit, so check the following characters for
      // more digits of the same number.
      final List<String> digits = [char];
      for (int i = x + 1; i < lines[y].length; ++i) {
        final nextChar = lines[y][i];
        if (!isDigit(nextChar)) break;
        digits.add(nextChar);
      }

      // Now we can check if any of the adjacent characters are symbols.
      final adjacentToSymbol = getAdjacentChars(lines, x, y, digits.length)
          .any((char) => char != '.' && !isDigit(char));
      if (adjacentToSymbol) {
        partNumbers[(x, y)] = int.parse(digits.join());
        x += digits.length - 1;
      }
    }
  }

  return partNumbers;
}

Iterable<int> getGearRatios(
    Map<Coord, int> partNumbers, String schematic) sync* {
  final lines = schematic.split('\n');

  /// The coordinates of all asterisks (*) in the schematic.
  List<Coord> asterisks = [];
  for (int y = 0; y < lines.length; ++y) {
    for (int x = 0; x < lines[y].length; ++x) {
      if (lines[y][x] == '*') {
        asterisks.add((x, y));
      }
    }
  }

  for (final gearCoord in asterisks) {
    final adjacentParts = partNumbers.keys
        .where((partCoord) {
          final dy = (gearCoord.$2 - partCoord.$2).abs();
          if (dy > 1) return false;
          final numDigits = partNumbers[partCoord]!.toString().length;
          for (int x = partCoord.$1; x < partCoord.$1 + numDigits; ++x) {
            final dx = (gearCoord.$1 - x).abs();
            if (dx <= 1) return true;
          }
          return false;
        })
        .map((partCoord) => partNumbers[partCoord]!)
        .toList();
    // Gears are asterisks (*) that are adjacent to exactly two part numbers.
    if (adjacentParts.length != 2) continue;
    // The gear ratio is the product of the two part numbers.
    final gearRatio = adjacentParts.reduce((a, b) => a * b);
    yield gearRatio;
  }
}

// Enumerates all the characters adjacent to the number,
// from the previous line, the current line, and the next line.
// Note that this includes the number itself.
Iterable<String> getAdjacentChars(
    List<String> lines, int x, int y, int numDigits) sync* {
  for (int y2 = max(0, y - 1); y2 <= y + 1 && y2 < lines.length; ++y2) {
    yield* lines[y2]
        .substring(
          max(0, x - 1),
          min(lines[y2].length, x + numDigits + 1),
        )
        .split('');
  }
}

bool isDigit(String char) =>
    char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57;

Future<void> main() async {
  final schematic = await File('assets/day_3.txt').readAsString();

  final partNumbers = getPartNumbers(schematic);
  final sumOfPartNumbers = partNumbers.values.reduce((a, b) => a + b);
  print('The sum of the part numbers is $sumOfPartNumbers');

  final gearRatios = getGearRatios(partNumbers, schematic);
  final sumOfGearRatios = gearRatios.reduce((a, b) => a + b);
  print('The sum of the gear ratios is $sumOfGearRatios');
}
