import 'dart:collection';
import 'dart:io';

var width = 25;
var height = 6;

void main(List<String> arguments) {
  File('data/08_space_image_format.txt').readAsString().then((String contents) {
    var layers = contents.length~/(width*height);
    var imageLayers = List<List<List<int>>>.generate(
        layers, (i) => List<List<int>>.generate(
        height, (j) => List<int>.generate(
        width, (k) => 0)));

    for (int i = 0; i < contents.length; i++) {
      imageLayers[i~/(width*height)][(i~/width)%height][i%width] = int.parse(contents[i]);
    }
    var rowWithFewestZeroesCount = rowWithFewestZeroes(imageLayers);
    print(rowWithFewestZeroesCount[0]);
    print(rowWithFewestZeroesCount[1]);
    print(rowWithFewestZeroesCount[2]);
    print(rowWithFewestZeroesCount[1]*rowWithFewestZeroesCount[2]);
    var imageData = getBinaryImage(imageLayers);
    printImage(imageData);
  });
}

Map<int, int> rowWithFewestZeroes(List<List<List<int>>> imageLayers) {
  var fewest = 151;
  Map<int, int> fewestLayerCounter;
  for (List<List<int>> imageLayer in imageLayers) {
    Map<int, int> counter = HashMap();
    for (List<int> row in imageLayer) {
      for (var pixel in row) {
        counter.putIfAbsent(pixel, () => 0);
        counter[pixel]++;
      }
    }
    if (fewest > counter[0]) {
      fewest = counter[0];
      fewestLayerCounter = counter;
    }
  }
  return fewestLayerCounter;
}

List<List<int>> getBinaryImage(List<List<List<int>>> imageLayers) {
  var imageData = List<List<int>>.generate(
      height, (i) => List<int>.generate(width, (j) => 0));
  for (var i = 0; i < height; i++) {
    for (var j = 0; j < width; j++) {
      for (var k = 0; k < imageLayers.length; k++) {
        if (imageLayers[k][i][j] != 2) {
          imageData[i][j] = imageLayers[k][i][j];
          break;
        }
      }
    }
  }

  return imageData;
}

void printImage(List<List<int>> imageData) {
  for (var row in imageData) {
    for (var point in row) {
      if (point == 0) {
        stdout.write(' ');
      } else {
        stdout.write('O');
      }
    }
    print('');
  }
}
