import 'dart:io';

import 'package:trotter/trotter.dart';

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

    /// Jokers can change into any card to get the best hand type.
    final numJokers = cardCountsMap[1]!;

    /// A list of the counts of each card,
    /// excluding the count of jokers which is replaced with 0.
    final cardCounts = cardCountsMap.values.toList()
      ..remove(numJokers)
      ..add(0);

    if (cardCounts.any((count) => count >= 5 - numJokers)) {
      return HandType.fiveOfAKind;
    }
    if (cardCounts.any((count) => count >= 4 - numJokers)) {
      return HandType.fourOfAKind;
    }

    HandType bestHandType = HandType.highCard;
    void setBestHandType(HandType handType) {
      if (handType.strength > bestHandType.strength) {
        bestHandType = handType;
      }
    }

    /// We now go through all the possible card counts
    /// where the jokers can be any card.
    for (final cardCounts in getAllPossibleCardCounts(
      numJokers,
      _cardStrengths.values,
      cardCountsMap,
    )) {
      if (cardCounts.contains(3) && cardCounts.contains(2)) {
        setBestHandType(HandType.fullHouse);
      } else if (cardCounts.contains(3)) {
        setBestHandType(HandType.threeOfAKind);
      } else if (cardCounts.where((count) => count == 2).length >= 2) {
        setBestHandType(HandType.twoPair);
      } else if (cardCounts.contains(2)) {
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

/// Returns all possible card counts for each combination of jokers,
/// which can be substituted for any card.
Iterable<List<int>> getAllPossibleCardCounts(
  int numJokers,
  Iterable<int> allCards,
  Map<int, int> cardCounts,
) sync* {
  if (numJokers == 0) {
    yield cardCounts.values.toList();
    return;
  } else {
    // Set the joker count to 0 so we don't have duplicates in the for loop.
    cardCounts[Hand._cardStrengths['J']!] = 0;
  }

  /// The list of all cards where each card is repeated [numJokers] times.
  final possibleJokers = List.generate(numJokers, (index) => allCards.toList())
      .fold([], (union, element) => union..addAll(element));

  /// We have to use the indexes of [possibleJokers] since duplicates aren't allowed.
  final combinations =
      Combinations(numJokers, List.generate(possibleJokers.length, (i) => i));

  for (final combination in combinations()) {
    final newCardCounts = Map<int, int>.from(cardCounts);
    for (final cardIndex in combination) {
      final card = possibleJokers[cardIndex];
      newCardCounts[card] = (newCardCounts[card] ?? 0) + 1;
    }
    yield newCardCounts.values.toList();
  }
}

Future<void> main() async {
  final input = await File('assets/day_7.txt').readAsLines();

  final hands = input.map(Hand.fromInput).toList();
  final totalWinnings = Hand.getWinnings(hands).reduce((a, b) => a + b);
  print('Total winnings: $totalWinnings');
}
