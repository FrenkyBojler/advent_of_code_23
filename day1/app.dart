import 'dart:io';

const mapOfNumbers = {
  'one': '1',
  'two': '2',
  'three': '3',
  'four': '4',
  'five': '5',
  'six': '6',
  'seven': '7',
  'eight': '8',
  'nine': '9'
};

void main() {
  int sum = 0;

  File('day1/input.txt').readAsLinesSync().forEach((line) {
    final indexesOfNumbers = mapNumbersToIndexesFromStrings(line);
    indexesOfNumbers.removeWhere((element) => element.length == 0);

    String firstNumber = getFirstNumberOfString(line, indexesOfNumbers) ?? '';
    String lastNumber = getLastNumberOfString(line, indexesOfNumbers) ?? '';

    sum += int.tryParse('${firstNumber}${lastNumber}') ?? 0;
  });

  print(sum);
}

String? getFirstNumberOfString(
    String string, List<List<MapEntry<String, int>>> indexesOfNumbers) {
  final indexes = indexesOfNumbers.expand((element) => element);

  final firstNumber = indexes.length != 0
      ? indexes.reduce(
          (value, element) => value.value < element.value ? value : element)
      : -1;

  final firstNumberWithIndex = indexes.firstWhere(
      (element) => element == firstNumber,
      orElse: () => MapEntry('', -1));

  for (int i = 0; i < string.length; i++) {
    if (int.tryParse(string[i]) != null &&
        (i < firstNumberWithIndex.value || firstNumberWithIndex.value == -1)) {
      return string[i];
    }
  }

  return firstNumberWithIndex.value != -1
      ? getNumberFromMap(firstNumberWithIndex.key) ?? null
      : null;
}

String? getLastNumberOfString(
    String string, List<List<MapEntry<String, int>>> indexesOfNumbers) {
  final indexes = indexesOfNumbers.expand((element) => element);

  final lastNumber = indexes.length != 0
      ? indexes.reduce(
          (value, element) => value.value > element.value ? value : element)
      : -1;

  final lastNumberWithIndex = indexes.firstWhere(
      (element) => element == lastNumber,
      orElse: () => MapEntry('', -1));

  for (int i = string.length - 1; i >= 0; i--) {
    if (int.tryParse(string[i]) != null && i > lastNumberWithIndex.value) {
      return string[i];
    }
  }

  return lastNumberWithIndex.value != -1
      ? getNumberFromMap(lastNumberWithIndex.key) ?? null
      : null;
}

String? getNumberFromMap(String number) {
  return mapOfNumbers[number];
}

List<List<MapEntry<String, int>>> mapNumbersToIndexesFromStrings(
    String string) {
  return mapOfNumbers.keys.map((key) {
    final indexesMap = getIndexesOfAllOccurencesOfString(string, key)
        .map((e) => MapEntry(key, e));

    indexesMap.toList().removeWhere((element) => element.value == -1);

    return indexesMap.toList();
  }).toList();
}

List<int> getIndexesOfAllOccurencesOfString(String string, String substring) {
  final indexes = <int>[];

  for (int i = 0; i < string.length - substring.length + 1; i++) {
    if (string.substring(i, i + substring.length) == substring) {
      indexes.add(i);
    }
  }

  return indexes;
}
