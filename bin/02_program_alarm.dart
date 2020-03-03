import 'dart:io';

import 'package:AoC_2019_Dart/Common.dart';

void main(List<String> arguments) {
  File('data/02_program_alarm.txt').readAsString().then((String contents) {
    var instructions = contents.split(',').map(int.parse).toList();
    print(getOutputAlarm(List.from(instructions)));
    print(findOutputAlarm(List.from(instructions)));
  });
}

int getOutputAlarm(List<int> instructions) {
  instructions[1] = 12;
  instructions[2] = 2;

  return executeOutputAlarm(instructions);
}

int findOutputAlarm(List<int> instructions) {
  for (var noun = 50; noun < 100; noun++) {
    for (var verb = 0; verb < 20; verb++) {
      instructions[1] = noun;
      instructions[2] = verb;
      if (executeOutputAlarm(List.from(instructions)) == 19690720) {
        return noun * 100 + verb;
      }
    }
  }
  return -1;
}

int executeOutputAlarm(List<int> instructions) {
  var machine = IntCode(instructions);
  var success = machine.run();
  return success ? machine.instructions[0] : -1;
}
