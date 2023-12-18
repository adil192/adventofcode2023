import 'dart:io';

/// A list of words that can be used to represent numbers.
/// E.g. numberWords[1] == 'one'
///
/// Note that the challenge doesn't accept 'zero' as a number,
/// but it's included to keep the indices consistent.
const numberWords = [
  'zero',
  'one',
  'two',
  'three',
  'four',
  'five',
  'six',
  'seven',
  'eight',
  'nine',
];

/// Gets the first and last digit in the line
/// and concatenates them.
/// e.g. ab1cd3ef => 13
int getCalibrationValue(String line) {
  assert(!line.contains('\n'));

  final chars = line.split('');

  int? firstDigit;
  int? lastDigit;

  // forward search
  for (int i = 0; i < chars.length; i++) {
    final digit = getNumberAtPos(line, i);
    if (digit != null) {
      firstDigit = digit;
      break;
    }
  }
  // backward search
  for (int i = chars.length - 1; i >= 0; i--) {
    final digit = getNumberAtPos(line, i);
    if (digit != null) {
      lastDigit = digit;
      break;
    }
  }

  if (firstDigit == null || lastDigit == null) {
    throw ArgumentError.value(line, 'line', 'No digits found');
  }

  return firstDigit * 10 + lastDigit;
}

/// Checks if [line] contains a number at [index], and returns it.
/// Returns null if no number is found.
///
/// The number can also be spelt out, e.g. "one" or "two".
int? getNumberAtPos(String line, int index) {
  // first check if it's a digit character
  final c = line[index];
  if (c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57) {
    return int.parse(c);
  }

  // then check if it's a word
  return _isWordAtPos(line, index);
}

/// Checks if a number is spelled out beginning at [index] in [line].
int? _isWordAtPos(String line, int index) {
  final possibilities = numberWords.toList();
  possibilities.removeAt(0); // remove 'zero'

  // (there are max 5 letters in a number word)
  for (int c = 0; c < 5; c++) {
    for (int w = 0; w < possibilities.length; w++) {
      final word = possibilities[w];
      if (line.length <= index + c ||
          word.length <= c ||
          line[index + c] != word[c]) {
        possibilities.removeAt(w);
        w--;
      } else if (word.length == c + 1) {
        // word is complete
        return numberWords.indexOf(word);
      }
    }
  }
  assert(possibilities.isEmpty);
  return null;
}

Future<int> main() async {
  final lines = await File('assets/day_1.txt').readAsLines();
  final calibrationValues = lines.map(getCalibrationValue);
  final sum = calibrationValues.reduce((a, b) => a + b);
  print(sum);
  return sum;
}
