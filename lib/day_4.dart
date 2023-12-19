import 'dart:io';
import 'dart:math';

class Card {
  Card(this.winningNumbers, this.myNumbers);

  factory Card.fromRawTable(String line) {
    // First remove the "Card 0: " prefix, since we don't need it.
    line = line.substring(line.indexOf(':') + 2);
    final [winningString, myString] = line.split(' | ');
    final winningNumbers =
        winningString.trim().split(RegExp(r' +')).map(int.parse).toList();
    final myNumbers =
        myString.trim().split(RegExp(r' +')).map(int.parse).toList();
    return Card(winningNumbers, myNumbers);
  }

  final List<int> winningNumbers;
  final List<int> myNumbers;

  int get numWins {
    return winningNumbers.where((n) => myNumbers.contains(n)).length;
  }

  int get points {
    final numWins = this.numWins;
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
