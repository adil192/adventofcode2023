import 'dart:io';

/// Gets the first and last digit in the line
/// and concatenates them.
/// e.g. ab1cd3ef => 13
int getCalibrationValue(String line) {
  assert(!line.contains('\n'));

  final chars = line.split('');

  String firstDigit = chars.firstWhere((c) => isDigit(c));
  String lastDigit = chars.lastWhere((c) => isDigit(c));

  return int.parse('$firstDigit$lastDigit');
}

bool isDigit(String c) {
  return c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;
}

Future<int> main() async {
  final lines = await File('assets/week1.txt').readAsLines();
  final calibrationValues = lines.map(getCalibrationValue);
  final sum = calibrationValues.reduce((a, b) => a + b);
  print(sum);
  return sum;
}
