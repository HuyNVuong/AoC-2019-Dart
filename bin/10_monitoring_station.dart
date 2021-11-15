import 'dart:io';
import 'dart:math';
import 'package:AoC_2019_Dart/Common.dart';

void main(List<String> arguments) {
  File('data/10_monitoring_station.txt').readAsString().then((String contents) {
    var lines = contents.split('\n');
    var height = lines.length;
    var width = lines[0].trim().length;
    var map = List<List<int>>.generate
      (height, (i) => List<int>.generate
      (width, (j) => 0));
    for (var i = 0; i < height; i++) {
      for (var j = 0; j < width; j++) {
        map[i][j] = lines[i][j] == '.' ? 0 : 1;
      }
    }
    List<Point> asteroidLocations = getAllAsteroidLocations(map);
    print(mostObservableAsteroids(map, asteroidLocations));
    var base = mostObservableLocation(map, asteroidLocations);
    print(base);
    wipeAsteroidsFromPoint(base, asteroidLocations);
  });
}

int mostObservableAsteroids(List<List<int>> map, List<Point> asteroidLocations) {
  var mostObservable = 0;
  for (var i = 0; i < map.length; i++) {
    for (var j = 0; j < map[i].length; j++) {
      if (map[i][j] == 1) {
        mostObservable = max(mostObservable, countVisibleAsteroids(Point(j, i), asteroidLocations));
      }
    }
  }

  return mostObservable;
}

int countVisibleAsteroids(Point point, List<Point> asteroidLocations) {
  var slopes = <Point>{};
  for (Point p in asteroidLocations) {
    if (point.slope(p) != null) {
      slopes.add(point.slope(p));
    }
  }

  return slopes.length;
}

List<Point> getAllAsteroidLocations(List<List<int>> map) {
  var locations = <Point>[];
  for (var i = 0; i < map.length; i++) {
    for (var j = 0; j < map[i].length; j++) {
      if (map[i][j] == 1) {
        locations.add(Point(j, i));
      }
    }
  }

  return locations;
}

void wipeAsteroidsFromPoint(Point base, List<Point> asteroidLocations) {
  var slopes = computeSlopeFromBase(base, asteroidLocations);
  var angles = []..addAll(slopes.keys);
//  angles.sort((a, b) => fauxAngle(a).y < fauxAngle(b).y ? -1
//                      : fauxAngle(a).y > fauxAngle(b).y ? 1
//                      : fauxAngle(a).x > fauxAngle(b).x ? -1
//                      : fauxAngle(a).x < fauxAngle(b).x ? 1 : 0);
  print(angles);
  print(fauxAngle(Point(8,3).slope(Point(8,1))));
  print(fauxAngle(Point(8,3).slope(Point(9,0))));
  print(fauxAngle(Point(8,3).slope(Point(9,1))));
  print(fauxAngle(Point(8,3).slope(Point(10,0))));
  print(fauxAngle(Point(8,3).slope(Point(9,2))));
  print(fauxAngle(Point(8,3).slope(Point(10,1))));
  print(fauxAngle(Point(8,3).slope(Point(11,1))));
  print(fauxAngle(Point(8,3).slope(Point(10,2))));
  print(fauxAngle(Point(8,3).slope(Point(14,1))));
  print(fauxAngle(Point(8,3).slope(Point(11,2))));
//  angles.forEach((a) => print(fauxAngle(a)));
}

class FauxAngle {
  double x;
  double y;

  FauxAngle(double x, double y) {
    this.x = x;
    this.y = y;
  }

  @override
  String toString() {
    return 'Angle(${x},${y})';
  }
}

FauxAngle fauxAngle(Point point) {
//  print(point);
  var dx = point.x;
  var dy = point.y;
  if(dx == 0 && dy < 0) {
    return FauxAngle(0, 0);
  } else if(dx > 0 && dy < 0) {
    return FauxAngle(1, dx / dy.abs());
  } else if(dx > 0 && dy == 0) {
    return FauxAngle(2, 0);
  } else if(dx > 0 && dy > 0) {
    return FauxAngle(3, dy / dx);
  } else if(dx == 0 && dy > 0) {
    return FauxAngle(4, 0);
  } else if(dx < 0 && dy > 0) {
    return FauxAngle(5, dx.abs() / dy);
  } else if(dx < 0 && dy == 0) {
    return FauxAngle(6, 0);
  } else {
    return FauxAngle(7, dy /dx);
  }
}

Map<Point, List<Point>> computeSlopeFromBase(Point base, List<Point> asteroidLocations) {
  var pointsBySlope = <Point, List<Point>>{};
  for (var p in asteroidLocations) {
    if (base.slope(p) != null) {
      pointsBySlope.putIfAbsent(base.slope(p), () => <Point>[]);
      pointsBySlope[base.slope(p)].add(p);
    }
  }
  for (var points in pointsBySlope.values) {
    points.sort((a, b) => a.manhattanDistance(base) - b.manhattanDistance(base));
  }

  return pointsBySlope;
}

Point mostObservableLocation(List<List<int>> map, List<Point> asteroidLocations) {
  var mostObservable = 0;
  var location;
  for (var i = 0; i < map.length; i++) {
    for (var j = 0; j < map[i].length; j++) {
      if (map[i][j] == 1) {
        if (mostObservable < countVisibleAsteroids(Point(j, i), asteroidLocations)) {
          mostObservable = countVisibleAsteroids(Point(j, i), asteroidLocations);
          location = Point(j, i);
        }
      }
    }
  }

  return location;
}
