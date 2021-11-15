import 'dart:io';

import 'package:AoC_2019_Dart/Common.dart';

void main(List<String> arguments) {
  File('data/09_sensor_boost.txt').readAsString().then((String contents) {
    var instructions = contents.split(',').map(int.parse).toList();
    print(testBOOSTprogram(instructions));
  });
}

int testBOOSTprogram(List<int> instructions) {
  return diagnosticWithInput(instructions, [1])[0];
}

List<int> diagnosticWithInput(List<int> instructions, List<int> input) {
  var machine = IntCode(instructions, input = input);
  var success = machine.run();
  return success ? machine.output : [-1];
}