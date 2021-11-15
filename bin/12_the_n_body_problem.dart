import 'dart:collection';
import 'dart:io';

import 'dart:math';

const regex = r'([\d-]+)';

class Moon {
  ThreePoint position;
  ThreePoint velocity;
  Moon(ThreePoint position) {
    this.position = position;
    this.velocity = ThreePoint(0, 0, 0);
  }

  @override
  String toString() {
    return '${position}, ${velocity}';
  }
}

class ThreePoint {
  int x;
  int y;
  int z;

  ThreePoint(int x, int y, int z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  add(ThreePoint other) {
    this.x += other.x;
    this.y += other.y;
    this.z += other.z;
  }

  @override
  String toString() {
    return '(${x}, ${y}, ${z})';
  }
}

void main(List<String> arguments) {
  File('./data/12_the_n_body_problem.txt').readAsString().then((String contents) {
    var lines = contents.split('\n');
    var expression = new RegExp(regex);
    var moons = <Moon>[];
    for (var line in lines) {
      var matches = expression.allMatches(line);
      var point = matches.map((match) => int.parse(match.group(0))).toList();
      moons.add(Moon(ThreePoint(point[0], point[1], point[2])));
    }
    energiesOfGravitationalMoon(moons, 10);
    print(rank([-1,2,3,4]));
    print(rank([10,10,3,6]));
    print(rank([-1,-7,-7,2]));
    print(rank([2,3,2,2]));
  });
}

void energiesOfGravitationalMoon(List<Moon> moons, int steps) {
  for (var i = 0; i < steps; i++) {
    var xPositionRanks = rank(moons.map((moon) => moon.position.x).toList());
    var yPositionRanks = rank(moons.map((moon) => moon.position.y).toList());
    var zPositionRanks = rank(moons.map((moon) => moon.position.z).toList());
    print(moons);
    xPositionRanks.forEach((rank, indexes) => {
       moons.forEach((moon) => moon.velocity.x += gravitationalStrengthFromRank(xPositionRanks, rank))
    });
    yPositionRanks.forEach((rank, indexes) => {
       indexes.forEach((i) => moons[i].velocity.y += gravitationalStrengthFromRank(yPositionRanks, rank))
    });
    zPositionRanks.forEach((rank, indexes) => {
       indexes.forEach((i) => moons[i].velocity.z += gravitationalStrengthFromRank(zPositionRanks, rank))
    });

    for (var moon in moons) {
      moon.position.add(moon.velocity);
    }
  }
}

Map<int, List<int>> rank(List<int> arr) {
  var tm = SplayTreeMap<int, List<int>>();
  for (var i = 0; i < arr.length; i++) {
    tm.putIfAbsent(arr[i], () => <int>[]);
    tm[arr[i]].add(i);
  }
  var rank = 0;
  var ranks = List<int>.generate(arr.length, (i) => 0);
//  print(tm);
  for (var values in tm.values) {
    for (var v in values) {
      ranks[v] = rank;
    }
    rank++;
  }
  var rankCount = SplayTreeMap<int, List<int>>();
  for (var i = 0; i < ranks.length; i++) {
    rankCount.putIfAbsent(ranks[i], () => <int>[]);
    rankCount[ranks[i]].add(i);
  }
//  print(ranks);

  return rankCount;
}

int gravitationalStrengthFromRank(Map<int, List<int>> rankCount, int rank) {
  var strength = 0;
  print(rankCount);
  for (var k in rankCount.keys) {
    if (k != rank) {
      strength = k < rank ? strength + rankCount[k].length : strength - rankCount[k].length;
    }
  }

  return strength;
}