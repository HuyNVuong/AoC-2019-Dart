import 'dart:io';

void main(List<String> arguments) {
  File('data/01_tyranny_of_the_rocket_equation.txt')
      .readAsString()
      .then((String contents) {
    var masses = contents.split('\n').map(int.parse).toList();
    ;
    print(totalRequiredFuel(masses));
    print(totalWeightedRequiredFuel(masses));
  });
}

int totalRequiredFuel(List<int> masses) {
  var fuelRequired = 0;
  for (var mass in masses) {
    fuelRequired += mass ~/ 3 - 2;
  }
  return fuelRequired;
}

int totalWeightedRequiredFuel(List<int> masses) {
  var fuelRequired = 0;
  for (var mass in masses) {
    while ((mass = mass ~/ 3 - 2) > 0) {
      fuelRequired += mass;
    }
  }
  return fuelRequired;
}
