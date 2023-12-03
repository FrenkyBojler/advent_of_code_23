import 'dart:io';

class Char {
  String value;
  int position;
  int get endPosition => position + value.length - 1;

  Char(this.value, this.position);

  @override
  String toString() {
    return 'Char{value: $value, position: $position}';
  }
}

class Symbol extends Char {
  bool get isGear => value == '*';
  Symbol(String value, int position) : super(value, position);

  @override
  String toString() {
    return 'Symbol{value: $value, position: $position}';
  }
}

class Number extends Char {
  get number => int.parse(value);

  Number(String value, int position) : super(value, position);

  @override
  String toString() {
    return 'Number{value: $value, position: [$position, ${endPosition}]';
  }
}

void main() {
  final schema = new File('day3/input.txt')
      .readAsLinesSync()
      .map((e) => getSchema(e))
      .toList();

  final numbers = getNumbersAdjecentToSymbols(schema);
  final sum = numbers.reduce((value, element) => value + element);
  print('Sum: $sum');

  final gearRatios =
      getGearRatios(schema).reduce((value, element) => value + element);
  print('Gear ratios: $gearRatios');
}

List<int> getGearRatios(List<List<Char>> schema) {
  List<int> gearRatios = [];

  for (int lineIndex = 0; lineIndex < schema.length; lineIndex++) {
    List<Char> line = schema[lineIndex];

    line.forEach((element) {
      if (element is Symbol && element.isGear) {
        List<Number> listOfNumbersUnique = [];

        [
          getLeftSymbol<Number>(element, lineIndex, schema),
          getRightSymbol<Number>(element, lineIndex, schema),
          getTopSymbol<Number>(element, lineIndex, schema),
          getBottomSymbol<Number>(element, lineIndex, schema),
          getTopLeftSymbol<Number>(element, lineIndex, schema),
          getTopRightSymbol<Number>(element, lineIndex, schema),
          getBottomLeftSymbol<Number>(element, lineIndex, schema),
          getBottomRightSymbol<Number>(element, lineIndex, schema)
        ].where((element) => element != null).forEach((element) {
          if (!listOfNumbersUnique.contains(element)) {
            listOfNumbersUnique.add(element!);
          }
        });

        if (listOfNumbersUnique.length == 2) {
          gearRatios.add(
              listOfNumbersUnique[0].number * listOfNumbersUnique[1].number);
        }
      }
    });
  }

  return gearRatios;
}

List<int> getNumbersAdjecentToSymbols(List<List<Char>> schema) {
  List<int> numbers = [];

  for (int lineIndex = 0; lineIndex < schema.length; lineIndex++) {
    List<Char> line = schema[lineIndex];

    line.forEach((element) {
      if (element is Number) {
        if ([
              getLeftSymbol<Symbol>(element, lineIndex, schema),
              getRightSymbol<Symbol>(element, lineIndex, schema),
              getTopSymbol<Symbol>(element, lineIndex, schema),
              getBottomSymbol<Symbol>(element, lineIndex, schema),
              getTopLeftSymbol<Symbol>(element, lineIndex, schema),
              getTopRightSymbol<Symbol>(element, lineIndex, schema),
              getBottomLeftSymbol<Symbol>(element, lineIndex, schema),
              getBottomRightSymbol<Symbol>(element, lineIndex, schema)
            ].where((element) => element != null).length >
            0) {
          numbers.add(element.number);
        }
      }
    });
  }

  return numbers;
}

List<Char> getSchema(String inputLine) {
  bool prevWasNumber = false;
  List<Char> schema = [];

  for (int i = 0; i < inputLine.length; i++) {
    String char = inputLine[i];
    if (char == '.') {
      prevWasNumber = false;
      continue;
    }

    int number = int.tryParse(char) ?? -1;

    if (number != -1) {
      if (prevWasNumber) {
        schema.last.value += char;
      } else {
        schema.add(Number(char, i));
      }

      prevWasNumber = true;
    } else {
      prevWasNumber = false;
      schema.add(Symbol(char, i));
    }
  }

  return schema;
}

extension ListExtension<T> on List<T> {
  T? elementAt(int index, {T Function()? orElse}) {
    if (index < 0 || index >= length) {
      return orElse != null ? orElse() : null;
    }

    return this[index];
  }

  T? whereFirstOrElse(bool Function(T element) test, T? Function() orElse) {
    for (T element in this) {
      if (test(element)) {
        return element;
      }
    }

    return orElse();
  }
}

void printSchema(List<List<Symbol>> schema) {
  for (int line = 0; line < schema.length; line++) {
    List<Symbol> symbols = schema[line];
    String lineString = '';

    for (int symbol = 0; symbol < symbols.length; symbol++) {
      lineString += ' | ${symbols[symbol]}';
    }

    print('Row: ${line}: ${lineString}');
  }
}

T? getCharOnPosition<T extends Char>(
    int position, int endPosition, int lineIndex, List<List<Char>> schema) {
  if (position < 0 || lineIndex < 0) {
    return null;
  }

  return schema.elementAtOrNull(lineIndex)?.whereFirstOrElse((element) {
    if (T == Symbol) {
      return element is T &&
          element.endPosition <= endPosition &&
          element.position >= position;
    } else if (T == Number) {
      return element is T &&
          ((element.endPosition >= position && element.position <= position) ||
              (element.endPosition >= position &&
                  element.position <= endPosition));
    } else {
      return false;
    }
  }, () => null) as T?;
}

T? getLeftSymbol<T extends Char>(
    Char symbol, int lineIndex, List<List<Char>> schema) {
  return getCharOnPosition(
      symbol.position - 1, symbol.endPosition, lineIndex, schema);
}

T? getRightSymbol<T extends Char>(
    Char symbol, int lineIndex, List<List<Char>> schema) {
  return getCharOnPosition(
      symbol.position, symbol.endPosition + 1, lineIndex, schema);
}

T? getTopSymbol<T extends Char>(
    Char symbol, int lineIndex, List<List<Char>> schema) {
  return getCharOnPosition(
      symbol.position, symbol.endPosition, lineIndex - 1, schema);
}

T? getBottomSymbol<T extends Char>(
    Char symbol, int lineIndex, List<List<Char>> schema) {
  return getCharOnPosition(
      symbol.position, symbol.endPosition, lineIndex + 1, schema);
}

T? getTopLeftSymbol<T extends Char>(
    Char symbol, int lineIndex, List<List<Char>> schema) {
  return getCharOnPosition(
      symbol.position - 1, symbol.endPosition, lineIndex - 1, schema);
}

T? getTopRightSymbol<T extends Char>(
    Char symbol, int lineIndex, List<List<Char>> schema) {
  return getCharOnPosition(
      symbol.position, symbol.endPosition + 1, lineIndex - 1, schema);
}

T? getBottomLeftSymbol<T extends Char>(
    Char symbol, int lineIndex, List<List<Char>> schema) {
  return getCharOnPosition(
      symbol.position - 1, symbol.endPosition, lineIndex + 1, schema);
}

T? getBottomRightSymbol<T extends Char>(
    Char symbol, int lineIndex, List<List<Char>> schema) {
  return getCharOnPosition(
      symbol.position, symbol.endPosition + 1, lineIndex + 1, schema);
}
