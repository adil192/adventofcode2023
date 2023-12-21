import 'package:adventofcode2023/day_7.dart';
import 'package:test/test.dart';

const _egInput = '''32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483''';

void main() {
  group('Day 7', () {
    late final List<Hand> hands;
    setUpAll(() {
      hands = _egInput.split('\n').map(Hand.fromInput).toList();
    });

    test('Hand.fromInput', () {
      final firstLine = _egInput.split('\n').first;
      final hand = Hand.fromInput(firstLine);
      expect(hand.cards, [3, 2, 10, 3, 13]);
      expect(hand.bet, 765);
      expect(hand.handType, HandType.onePair);
    });
    test('Hand.getHandRanks, Hand.getWinnings', () {
      final ranks = Hand.getHandRanks(hands).toList();
      final winnings = Hand.getWinnings(hands).toList();

      expect(ranks.length, 5);
      Hand hand;
      int rank;

      (hand, rank) = ranks[0];
      expect(hand.bet, 765);
      expect(rank, 1);
      expect(winnings[0], 765 * 1);

      (hand, rank) = ranks[1];
      expect(hand.bet, 220);
      expect(rank, 2);
      expect(winnings[1], 220 * 2);

      (hand, rank) = ranks[2];
      expect(hand.bet, 28);
      expect(rank, 3);
      expect(winnings[2], 28 * 3);

      (hand, rank) = ranks[3];
      expect(hand.bet, 684);
      expect(rank, 4);
      expect(winnings[3], 684 * 4);

      (hand, rank) = ranks[4];
      expect(hand.bet, 483);
      expect(rank, 5);
      expect(winnings[4], 483 * 5);
    });
  });
}
