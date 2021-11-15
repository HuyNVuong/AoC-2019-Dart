import 'dart:io';

import 'package:AoC_2019_Dart/Common.dart';

void main(List<String> arguments) {
  File('data/13_care_package.txt').readAsString().then((String contents) {
    var instructions = contents.split(',').map(int.parse).toList();
    print(getOutputsFromInstructions(instructions));
  });
}

List<int> getOutputsFromInstructions(List<int> instructions) {
  var machine = IntCode(instructions);
  machine.run();
  return machine.output;
}