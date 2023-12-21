import 'dart:io';

class Hand implements Comparable<Hand> {
  /// Initializes a hand with the string representation of 5 cards.
  /// Each character can be A, K, Q, T, 9, 8, 7, 6, 5, 4, 3, 2, or J.
  /// The relative strength of each card follows this order,
  /// where A is the highest and J is the lowest.
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
  /// where A (13) is the highest and 2 is the lowest.
  final List<int> cards = List.filled(5, 0);

  late final handType = _getHandType();

  /// The bet associated with this hand.
  final int bet;

  HandType _getHandType() {
    final cardCountsMap = <int, int>{
      1: 0, // Make sure jokers are included in the map.
    };
    for (final card in cards) {
      cardCountsMap[card] = (cardCountsMap[card] ?? 0) + 1;
    }
    final numJokers = cardCountsMap[1]!;

    /// A list of the counts of each card,
    /// excluding the count of jokers which is replaced with 0.
    final cardCounts = cardCountsMap.values.toList()
      ..remove(numJokers)
      ..add(0);

    /// Jokers can change into any card to get the best hand type.
    HandType bestHandType = HandType.highCard;
    void setBestHandType(HandType handType) {
      if (handType.strength > bestHandType.strength) {
        bestHandType = handType;
      }
    }

    for (int jokers = 0; jokers <= numJokers; ++jokers) {
      if (cardCounts.contains(5 - jokers)) {
        setBestHandType(HandType.fiveOfAKind);
        break;
      }
      if (cardCounts.contains(4 - jokers)) {
        setBestHandType(HandType.fourOfAKind);
      }
      // A full house is made with 3 of a kind + 2 of a kind,
      // so we need another loop to split the jokers between these
      // two counts.
      for (int j = 0; j <= jokers; ++j) {
        if (cardCounts.contains(3 - j) &&
            cardCounts.contains(2 - (jokers - j))) {
          setBestHandType(HandType.fullHouse);
        }
      }
      if (cardCounts.contains(3 - jokers)) {
        setBestHandType(HandType.threeOfAKind);
      }
      // A two pair is made with 2 of a kind + 2 of a kind,
      // so we need another loop to split the jokers between these
      // two counts.
      for (int j = 0; j <= jokers; ++j) {
        if (j == jokers - j) {
          // We need to check that there both pairs not just one.
          if (!cardCounts.contains(2 - j)) continue;
          if (cardCounts.where((count) => count == 2 - j).length >= 2) {
            setBestHandType(HandType.twoPair);
          }
        } else {
          if (cardCounts.contains(2 - j) &&
              cardCounts.contains(2 - (jokers - j))) {
            setBestHandType(HandType.twoPair);
          }
        }
      }
      if (cardCounts.contains(2 - jokers)) {
        setBestHandType(HandType.onePair);
      }
    }

    return bestHandType;
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
    'A': 13,
    'K': 12,
    'Q': 11,
    'T': 10,
    '9': 9,
    '8': 8,
    '7': 7,
    '6': 6,
    '5': 5,
    '4': 4,
    '3': 3,
    '2': 2,
    'J': 1,
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
