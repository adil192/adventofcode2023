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
      Hand hand;
      hand = hands[0];
      expect(hand.cards, [3, 2, 10, 3, 12]);
      expect(hand.bet, 765);
      expect(hand.handType, HandType.onePair);
      hand = hands[1];
      expect(hand.cards, [10, 5, 5, 1, 5]);
      expect(hand.bet, 684);
      expect(hand.handType, HandType.fourOfAKind);
      hand = hands[2];
      expect(hand.cards, [12, 12, 6, 7, 7]);
      expect(hand.bet, 28);
      expect(hand.handType, HandType.twoPair);
      hand = hands[3];
      expect(hand.cards, [12, 10, 1, 1, 10]);
      expect(hand.bet, 220);
      expect(hand.handType, HandType.fourOfAKind);
      hand = hands[4];
      expect(hand.cards, [11, 11, 11, 1, 13]);
      expect(hand.bet, 483);
      expect(hand.handType, HandType.fourOfAKind);
    });

    test('Hand.handType fullHouse with jokers', () {
      Hand hand;
      hand = Hand.fromInput('33322 1');
      expect(hand.handType, HandType.fullHouse);
      hand = Hand.fromInput('3332J 1');
      expect(hand.handType, HandType.fourOfAKind);
      hand = Hand.fromInput('33J22 1');
      expect(hand.handType, HandType.fullHouse);
      hand = Hand.fromInput('33J2J 1');
      expect(hand.handType, HandType.fourOfAKind);
      hand = Hand.fromInput('33JJJ 1');
      expect(hand.handType, HandType.fiveOfAKind);
      hand = Hand.fromInput('3JJJJ 1');
      expect(hand.handType, HandType.fiveOfAKind);
    });

    test('QJJQ2', () {
      final hand = Hand.fromInput('QJJQ2 1');
      expect(hand.handType, HandType.fourOfAKind);
    });
    test('JKKK2 vs QQQQ2', () {
      final hand1 = Hand.fromInput('JKKK2 1');
      final hand2 = Hand.fromInput('QQQQ2 1');
      expect(hand1.compareTo(hand2), lessThan(0));
    });

    test('Hand.getHandRanks, Hand.getWinnings', () {
      final ranks = Hand.getHandRanks(hands).toList();
      final winnings = Hand.getWinnings(hands).toList();

      expect(ranks.length, 5);
      Hand hand;
      int rank;

      (hand, rank) = ranks[0];
      expect(hand.bet, 765);
      expect(hand.handType, HandType.onePair);
      expect(rank, 1);
      expect(winnings[0], 765 * 1);

      (hand, rank) = ranks[1];
      expect(hand.bet, 28);
      expect(hand.handType, HandType.twoPair);
      expect(rank, 2);
      expect(winnings[1], 28 * 2);

      (hand, rank) = ranks[2];
      expect(hand.bet, 684);
      expect(hand.handType, HandType.fourOfAKind);
      expect(rank, 3);
      expect(winnings[2], 684 * 3);

      (hand, rank) = ranks[3];
      expect(hand.bet, 483);
      expect(hand.handType, HandType.fourOfAKind);
      expect(rank, 4);
      expect(winnings[3], 483 * 4);

      (hand, rank) = ranks[4];
      expect(hand.bet, 220);
      expect(hand.handType, HandType.fourOfAKind);
      expect(rank, 5);
      expect(winnings[4], 220 * 5);
    });
  });
}
