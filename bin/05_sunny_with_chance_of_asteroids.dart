import 'dart:io';

import 'package:AoC_2019_Dart/Common.dart';

void main(List<String> arguments) {
  File('data/05_sunny_with_a_chance_of_asteroids.txt')
      .readAsString()
      .then((String contents) {
    var instructions = contents.split(',').map(int.parse).toList();
    print(diagnosticWithInput(instructions, 1));
    instructions = contents.split(',').map(int.parse).toList();
    print(diagnosticWithInput(instructions, 5));
  });
}

List<int> diagnosticWithInput(List<int> instructions, int input) {
  var machine = IntCode(instructions, input = input);
  var success = machine.run();
  return success ? machine.output : [-1];
}
