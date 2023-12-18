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

      // We'll first get all the characters adjacent to the number,
      // from the previous line, the current line, and the next line.
      // Note that this includes the number itself.
      final adjacentChars = <String>[];
      for (int y2 = max(0, y - 1); y2 <= y + 1 && y2 < lines.length; ++y2) {
        adjacentChars.addAll(lines[y2]
            .substring(
              max(0, x - 1),
              min(lines[y2].length, x + digits.length + 1),
            )
            .split(''));
      }

      // Now we can check if any of the adjacent characters are symbols.
      final adjacentToSymbol =
          adjacentChars.any((char) => char != '.' && !isDigit(char));
      if (adjacentToSymbol) {
        partNumbers[(x, y)] = int.parse(digits.join());
        x += digits.length - 1;
      }
    }
  }

  return partNumbers;
}

bool isDigit(String char) =>
    char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57;

Future<void> main() async {
  final schematic = await File('assets/day_3.txt').readAsString();
  final partNumbers = getPartNumbers(schematic);
  final sumOfPartNumbers = partNumbers.values.reduce((a, b) => a + b);
  print('The sum of the part numbers is $sumOfPartNumbers');
}
