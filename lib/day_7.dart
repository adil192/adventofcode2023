import 'dart:io';

class Hand implements Comparable<Hand> {
  /// Initializes a hand with the string representation of 5 cards.
  /// Each character can be A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, or 2.
  /// The relative strength of each card follows this order,
  /// where A is the highest and 2 is the lowest.
  Hand(String hand, {required this.bet}) {
    assert(hand.length == 5);
    final cards = hand.split('');
    for (var i = 0; i < cards.length; i++) {
      this.cards[i] = _cardStrengths[cards[i]]!;
    }
  }

  /// Initializes a hand from a line of input.
  /// This is in the format of '23456 100', where the first 5 characters
  /// represent the cards and the remaining number is the bet.
  factory Hand.fromInput(String input) {
    final [cards, bet] = input.split(' ');
    return Hand(cards, bet: int.parse(bet));
  }

  /// A fixed length list of 5 cards, populated in the constructor.
  /// Each card is represented by its relative strength,
  /// where A (14) is the highest and 2 is the lowest.
  final List<int> cards = List.filled(5, 0);

  late final handType = _getHandType();

  /// The bet associated with this hand.
  final int bet;

  HandType _getHandType() {
    final cardCounts = <int, int>{};
    for (final card in cards) {
      cardCounts[card] = (cardCounts[card] ?? 0) + 1;
    }

    if (cardCounts.containsValue(5)) {
      return HandType.fiveOfAKind;
    }
    if (cardCounts.containsValue(4)) {
      return HandType.fourOfAKind;
    }
    if (cardCounts.containsValue(3) && cardCounts.containsValue(2)) {
      return HandType.fullHouse;
    }
    if (cardCounts.containsValue(3)) {
      return HandType.threeOfAKind;
    }
    if (cardCounts.values.where((count) => count == 2).length == 2) {
      return HandType.twoPair;
    }
    if (cardCounts.containsValue(2)) {
      return HandType.onePair;
    }
    return HandType.highCard;
  }

  @override
  int compareTo(Hand other) {
    if (handType.strength != other.handType.strength) {
      return handType.strength.compareTo(other.handType.strength);
    }

    // For hands of the same type, compare the cards in order.
    for (var i = 0; i < cards.length; i++) {
      if (cards[i] != other.cards[i]) {
        return cards[i].compareTo(other.cards[i]);
      }
    }

    // All cards are equal.
    return 0;
  }

  /// Returns the hands in a tuple with their rank,
  /// where the weakest hand has rank 1,
  /// the second-weakest hand has rank 2, etc.
  static Iterable<(Hand hand, int rank)> getHandRanks(List<Hand> hands) sync* {
    hands.sort();
    for (int i = 0; i < hands.length; ++i) {
      yield (hands[i], i + 1);
    }
  }

  /// Each hand wins an amount equal to its bid multiplied by its rank.
  static Iterable<int> getWinnings(List<Hand> hands) sync* {
    for (final (hand, rank) in getHandRanks(hands)) {
      yield rank * hand.bet;
    }
  }

  @override
  String toString() => 'Hand($cards, bet=$bet)';
  @override
  bool operator ==(other) => other is Hand && cards == other.cards;
  @override
  int get hashCode => cards.hashCode;

  /// Maps each card to its relative strength.
  static const _cardStrengths = <String, int>{
    'A': 14,
    'K': 13,
    'Q': 12,
    'J': 11,
    'T': 10,
    '9': 9,
    '8': 8,
    '7': 7,
    '6': 6,
    '5': 5,
    '4': 4,
    '3': 3,
    '2': 2,
  };
}

enum HandType {
  fiveOfAKind(7),
  fourOfAKind(6),
  fullHouse(5),
  threeOfAKind(4),
  twoPair(3),
  onePair(2),
  highCard(1),
  ;

  const HandType(this.strength);

  final int strength;
}

Future<void> main() async {
  final input = await File('assets/day_7.txt').readAsLines();

  final hands = input.map(Hand.fromInput).toList();
  final totalWinnings = Hand.getWinnings(hands).reduce((a, b) => a + b);
  print('Total winnings: $totalWinnings');
}
