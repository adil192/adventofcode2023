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

  /// Part 2:
  /// Returns the count of each card after all the originals and copies
  /// have been processed.
  ///
  /// [originalCards] are assumed to have card 1 at index 0, card 2 at index 1,
  /// etc.
  static Map<Card, int> getCopies(List<Card> originalCards) {
    final toProcess = <Card>[];
    final numCards = <Card, int>{};
    for (final card in originalCards) {
      toProcess.add(card);
      numCards[card] = 1;
    }

    while (toProcess.isNotEmpty) {
      final card = toProcess.removeLast();
      for (int cardNumber = card.cardNumber + 1;
          cardNumber <= card.cardNumber + card.numWins &&
              cardNumber <= originalCards.length;
          cardNumber++) {
        final newCard = originalCards[cardNumber - 1];
        toProcess.add(newCard);
        numCards[newCard] = (numCards[newCard] ?? 0) + 1;
      }
    }

    return numCards;
  }
}

Future<void> main() async {
  final rawTable = await File('assets/day_4.txt').readAsLines();
  final cards = rawTable.map(Card.fromRawTable).toList();

  final totalPoints = cards.map((c) => c.points).reduce((a, b) => a + b);
  print('(Part 1) Total points: $totalPoints');

  final numCards = Card.getCopies(cards);
  final totalCards = numCards.values.reduce((a, b) => a + b);
  print('(Part 2) Total cards: $totalCards');
}
