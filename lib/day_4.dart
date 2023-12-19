import 'dart:io';
import 'dart:math';

class Card {
  Card(this.cardNumber, this.winningNumbers, this.myNumbers);

  factory Card.fromRawTable(String line) {
    // First get the "Card 0: " prefix
    final [id, lineWithoutId] = line.split(':');
    final cardNumber = int.parse(id.split(' ').last);

    final [winningString, myString] = lineWithoutId.split('|');
    final winningNumbers = winningString
        .trim()
        .split(RegExp(r' +'))
        .map(int.parse)
        .toList(growable: false);
    final myNumbers = myString
        .trim()
        .split(RegExp(r' +'))
        .map(int.parse)
        .toList(growable: false);

    return Card(cardNumber, winningNumbers, myNumbers);
  }

  final int cardNumber;
  final List<int> winningNumbers;
  final List<int> myNumbers;

  late final numWins =
      winningNumbers.where((n) => myNumbers.contains(n)).length;

  /// Part 1 only
  int get points {
    if (numWins == 0) return 0;
    return pow(2, numWins - 1) as int;
  }
}

Future<void> main() async {
  final rawTable = await File('assets/day_4.txt').readAsLines();
  final cards = rawTable.map(Card.fromRawTable).toList();

  final totalPoints = cards.map((c) => c.points).reduce((a, b) => a + b);
  print('Total points: $totalPoints');
}
