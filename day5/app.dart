import 'dart:io';
import 'dart:isolate';

void main() async {
  File file = new File('day5/input.txt');
  List<int> seeds = [];
  List<List<List<int>>> map = [];

  file.readAsLinesSync().forEach((String line) {
    if (seeds.isEmpty) {
      seeds = line.split(' ').map((e) => int.parse(e)).toList();
    } else {
      if (line.contains(';')) {
        map.add([]);
      } else {
        map.last.add(line.split(' ').map((e) => int.parse(e)).toList());
      }
    }
  });

  // part one
  /*final result = seeds.map((seed) {
    int source = seed;

    map.forEach((mapElement) {
      source = getDestinationPartOne(source, mapElement);
    });

    return source;
  });

  print(result.reduce((value, element) => value < element ? value : element));*/

  // part two

  List<int> result = [];

  for (int i = 0; i < seeds.length; i += 2) {
    int source = seeds[i];
    int length = seeds[i + 1];

    await Future.wait([
      for (int seed = source; seed <= source + length; seed++)
        Isolate.run(() => getDestinationForSeed(seed, map))
    ]).then((value) => result.add(
        value.reduce((value, element) => value < element ? value : element)));
  }

  print(result.reduce((value, element) => value < element ? value : element));
}

Map<int, int> result = {};
List<Map<int, int>> results = [];

Future<int> getDestinationForSeed(int seed, List<List<List<int>>> map) async {
  int currentSource = seed;
  if (result.containsKey(seed)) {
    print('skip');
    return result[seed]!;
  }
  int i = 0;
  map.forEach((mapElement) {
    /*if (results.length <= i) {
      results.add({});
    }

    if (results.elementAt(i).containsKey(currentSource)) {
      print('skip 2');
      currentSource = results[i][currentSource]!;
      return;
    }*/
    int originalSource = currentSource;
    currentSource = getDestinationPartOne(currentSource, mapElement);

    //results[i][originalSource] = currentSource;

    i++;
  });

  result[seed] = currentSource;
  return currentSource;
}

int getDestinationPartOne(int source, List<List<int>> map) {
  int result = -1;

  map.forEach((element) {
    final destinationStartIndex = element[0];
    final sourceStartIndex = element[1];
    final length = element[2];

    if (source < sourceStartIndex || source > sourceStartIndex + length) {
      return;
    }

    for (int i = 0; i < length; i++) {
      if (sourceStartIndex + i == source) {
        result = destinationStartIndex + i;
        break;
      }
    }

    if (result != -1) {
      return;
    }
  });

  return result != -1 ? result : source;
}
