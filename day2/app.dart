import 'dart:io';

const configuration = {
  'red': 12,
  'green': 13,
  'blue': 14,
};

class Game {
  int id;
  List<List<MapEntry<String, int>>> turns;

  Game(this.id, this.turns);

  bool gameSatisfiesConfiguration() {
    return turns.every((element) {
      return getSumRedByTurn(element) <= configuration['red']! &&
          getSumGreenByTurn(element) <= configuration['green']! &&
          getSumBlueByTurn(element) <= configuration['blue']!;
    });
  }

  int getPowerOfGame() {
    return configuration.keys
        .map((e) => getMinimumSumForColorToSatisfyConfiguration(e))
        .reduce((value, element) => value * element);
  }

  int getSumRedByTurn(List<MapEntry<String, int>> turn) {
    return getSumColorByTurn(turn, 'red');
  }

  int getSumGreenByTurn(List<MapEntry<String, int>> turn) {
    return getSumColorByTurn(turn, 'green');
  }

  int getSumBlueByTurn(List<MapEntry<String, int>> turn) {
    return getSumColorByTurn(turn, 'blue');
  }

  int getMinimumSumForColorToSatisfyConfiguration(String color) {
    final numberOfColorForEachTurn = turns.map((element) {
      return element
          .where((element) => element.key == color)
          .map((e) => e.value);
    }).expand((element) => element);

    return numberOfColorForEachTurn
        .reduce((value, element) => value >= element ? value : element);
  }

  int getSumColorByTurn(List<MapEntry<String, int>> turn, String color) {
    final colorsWithNumbers =
        turn.where((element) => element.key == color).map((e) => e.value);

    return colorsWithNumbers.length != 0
        ? colorsWithNumbers.reduce((value, element) => value + element)
        : 0;
  }

  @override
  String toString() {
    return 'Game $id: turns: $turns)';
  }
}

void main() {
  final games = File('day2/input.txt')
      .readAsLinesSync()
      .map((e) => parseGameFromGivenLine(e));

  final sum = games
      .where((element) => element.gameSatisfiesConfiguration())
      .map((e) => e.id)
      .reduce((value, element) {
    return value + element;
  });

  // first part
  print(sum);

  final power = games.map((e) => e.getPowerOfGame()).reduce((value, element) {
    return value + element;
  });

  // second part
  print(power);
}

Game parseGameFromGivenLine(String line) {
  final gameSplit = line.split(':');
  final game = gameSplit[0];
  final gameId = game.split(' ')[1];
  final turns = gameSplit[1].split(';');
  final colorsByTurns = turns.map((e) => e.split(',').map((colorWithNumber) {
        final colorNumberSplit = colorWithNumber.split(' ');
        final color = colorNumberSplit[2];
        final number = int.tryParse(colorNumberSplit[1]) ?? 0;
        return MapEntry(color, number);
      }).toList());

  return Game(int.tryParse(gameId) ?? -1, colorsByTurns.toList());
}
