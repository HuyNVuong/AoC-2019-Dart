import 'dart:collection';
import 'dart:io';

import 'dart:math';

import 'package:AoC_2019_Dart/Common.dart';

void main(List<String> arguments) {
  File('data/06_universal_orbit_map.txt').readAsString().then((String contents) {
    var rawMap = contents.split('\n');
    var directedAdjacencyList = HashMap<String, List<String>>();
    var undirectedAdjacencyList = HashMap<String, List<String>>();
    for (var entry in rawMap) {
      var edge = entry.split(')');
      var src = edge[0].trim();
      var dst = edge[1].trim();
      directedAdjacencyList.putIfAbsent(src, () => <String>[]);
      undirectedAdjacencyList.putIfAbsent(src, () => <String>[]);
      undirectedAdjacencyList.putIfAbsent(dst, () => <String>[]);
      directedAdjacencyList[src].add(dst);
      undirectedAdjacencyList[src].add(dst);
      undirectedAdjacencyList[dst].add(src);
    }
    print(countNumberOfOrbits(directedAdjacencyList));
    print(shortestToPath('YOU', 'SAN', undirectedAdjacencyList));
  });
}

int shortestToPath(String src, String dst, HashMap<String, List<String>> undirectedAdjacencyList) {
  var distance = 99999;
  var traversal = Queue<LevelNode>();
  traversal.add(new LevelNode(src, 0));
  var visited = <String>{};
  visited.add(src);
  while(!traversal.isEmpty) {
    LevelNode levelNode = traversal.removeLast();
    for (var vertex in undirectedAdjacencyList[levelNode.key]) {
      if (vertex == dst) {
        distance = min(distance, levelNode.level) - 1;
      }
      if (!visited.contains(vertex)) {
        traversal.add(new LevelNode(vertex, levelNode.level + 1));
        visited.add(vertex);
      }
    }
  }
  
  return distance;
}

int countNumberOfOrbits(HashMap<String, List<String>> directedAdjacencyList) {
  var n = 0;
  for (String root in directedAdjacencyList.keys) {
    n = max(n, countNumberOfOrbitsFromRoot(directedAdjacencyList, root));
  }

  return n;
}

var total;

int countNumberOfOrbitsFromRoot(HashMap<String, List<String>> directedAdjacencyList, String root) {
  var total = 0;
  void dfs(Map<String, List<String>> directedAdjacencyList, String vertex, int n) {
    var visited = <String>{};

    if (directedAdjacencyList[vertex] == null || directedAdjacencyList[vertex].isEmpty) {
      total += n;
      return;
    }

    for (String neighbor in directedAdjacencyList[vertex]) {
      if (!visited.contains(neighbor)) {
        visited.add(neighbor);
        dfs(directedAdjacencyList, neighbor, n + 1);
      }
    }

    total += n;
  }
  dfs(directedAdjacencyList, root, 0);
  return total;
}
