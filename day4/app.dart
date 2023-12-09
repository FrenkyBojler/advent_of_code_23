import 'dart:io';

void main() {
  final numbersForCards = new File('day4/input.txt')
      .readAsLinesSync()
      .map((e) => getNumbersForCard(e));

  final score = numbersForCards
      .map((e) => getScore(e.$1, e.$2))
      .reduce((value, element) => value + element);

  print(score);

  final numberOfCards = getNumberOfCards(numbersForCards.toList(), null, null);
  print(numberOfCards + numbersForCards.length);
}

int getNumberOfCards(
  List<(List<int>, List<int>)> numbersForCard,
  int? startIndex,
  int? endIndex,
) {
  int index = 0;
  int? realEndIndex = endIndex != null ? (startIndex ?? 0) + endIndex : null;
  return numbersForCard.sublist(startIndex ?? 0, realEndIndex).map((element) {
    final numberOfCards = getScore(
      element.$1,
      element.$2,
      secondPart: true,
    );

    int result = 0;

    if (numberOfCards != 0) {
      result = numberOfCards +
          getNumberOfCards(
            numbersForCard,
            (startIndex ?? 0) + index + 1,
            numberOfCards,
          );
    }

    index++;
    return result;
  }).fold(0, (value, element) => value + element);
}

int getScore(List<int> winningNumbers, List<int> drawedNumbers,
    {bool secondPart = false}) {
  int score = 0;

  drawedNumbers.forEach((element) {
    if (winningNumbers.contains(element)) {
      if (secondPart) {
        score += 1;
      } else {
        if (score == 0) {
          score = 1;
        } else {
          score *= 2;
        }
      }
    }
  });

  return score;
}

(List<int>, List<int>) getNumbersForCard(String card) {
  final split = card.split(':')[1].split('|');

  final winningNumbersString = split[0]
      .split(' ')
      .where((element) => element != '' && element != ' ')
      .toList();

  final drawedNumbersString = split[1]
      .split(' ')
      .where((element) => element != '' && element != ' ')
      .toList();

  return (
    winningNumbersString.map((e) => int.parse(e)).toList(),
    drawedNumbersString.map((e) => int.parse(e)).toList()
  );
}
