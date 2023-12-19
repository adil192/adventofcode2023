import 'package:adventofcode2023/day_4.dart';
import 'package:test/test.dart';

final _rawTable = '''Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11''';

void main() {
  group('Day 4', () {
    test('Card.fromRawTable', () {
      final card = Card.fromRawTable(_rawTable.split('\n').first);
      expect(card.cardNumber, 1);
      expect(card.winningNumbers, [41, 48, 83, 86, 17]);
      expect(card.myNumbers, [83, 86, 6, 31, 17, 9, 48, 53]);
      expect(card.numWins, 4);
      expect(card.points, 8);
    });

    test('Card.getCopies', () {
      final cards = _rawTable.split('\n').map(Card.fromRawTable).toList();
      final copies = Card.getCopies(cards);
      expect(copies[cards[0]], 1);
      expect(copies[cards[1]], 2);
      expect(copies[cards[2]], 4);
      expect(copies[cards[3]], 8);
      expect(copies[cards[4]], 14);
      expect(copies[cards[5]], 1);
    });
  });
}
