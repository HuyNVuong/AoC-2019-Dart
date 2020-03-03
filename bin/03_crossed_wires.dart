import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:AoC_2019_Dart/Common.dart';

void main(List<String> arguments) {
  File('data/03_crossed_wires.txt').readAsString().then((String contents) {
    var wires = contents.split('\n');
    print(closetsIntersection(wires));
    print(closetsDistanceToIntersection(wires));
  });
}

int closetsIntersection(List<String> wires) {
  var firstWire = moveWires(wires[0]);
  var secondWire = moveWires(wires[1]);
  var closets = 999999;
  for (var intersections in firstWire.intersection(secondWire)) {
    closets = min(closets, Point(0, 0).manhattanDistance(intersections));
  }
  return closets;
}

int closetsDistanceToIntersection(List<String> wires) {
  var firstWireWithStepCount = moveWiresWithStepCount(wires[0]);
  var secondWireWithStepCount = moveWiresWithStepCount(wires[1]);
  var closets = 999999;
  for (var firstWireMoves in firstWireWithStepCount.entries) {
    if (secondWireWithStepCount.containsKey(firstWireMoves.key)) {
      closets = min(
          firstWireMoves.value + secondWireWithStepCount[firstWireMoves.key],
          closets);
    }
  }
  return closets;
}

Set<Point> moveWires(String wire) {
  var moves = <Point>{};
  var x = 0, y = 0;
  for (var path in wire.split(',')) {
    var direction = path[0];
    var steps = int.parse(path.substring(1));
    for (var i = 0; i < steps; i++) {
      if (direction == 'U') {
        y -= 1;
      } else if (direction == 'D') {
        y += 1;
      } else if (direction == 'R') {
        x += 1;
      } else {
        x -= 1;
      }
      moves.add(Point(x, y));
    }
  }
  return moves;
}

Map<Point, int> moveWiresWithStepCount(String wire) {
  var x = 0, y = 0, steps = 0;
  var pointWithSteps = HashMap<Point, int>();
  for (var path in wire.split(',')) {
    var direction = path[0];
    var distance = int.parse(path.substring(1));
    for (var i = 0; i < distance; i++) {
      if (direction == 'U') {
        y -= 1;
      } else if (direction == 'D') {
        y += 1;
      } else if (direction == 'R') {
        x += 1;
      } else {
        x -= 1;
      }
      steps++;
      pointWithSteps[Point(x, y)] = steps;
    }
  }
  return pointWithSteps;
}
