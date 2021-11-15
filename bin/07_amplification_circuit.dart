import 'dart:io';
import 'dart:math';
import 'package:AoC_2019_Dart/Common.dart';
import 'package:trotter/trotter.dart';

void main(List<String> arguments) {
  File('data/07_amplification_circuit.txt').readAsString().then((String contents) {
    var instructions = contents.split(',').map(int.parse).toList();
    print(highestSignalFromThrusters(instructions));
  });
}

final thrusters = [0,1,2,3,4];
final feedbackThrusters = [5,6,7,8,9];

int highestSignalFromThrusters(List<int> instructions) {
  final thrustersPermutations = Permutations(5, thrusters);
  var highest = 0;

  for (final permutation in thrustersPermutations()) {
    var inputs = List<int>();
    var lastOutput = 0;
    for (var input in [0,4,1,3,2]) {
      inputs.add(input);
      inputs.add(lastOutput);
      List<int> clone = []..addAll(instructions);
      var outputs = diagnosticWithInput(clone, inputs);
      lastOutput = outputs[outputs.length - 1];
      inputs = List<int>();
    }
    if (lastOutput > highest) {
      highest = lastOutput;
      print(permutation);
    }
  }
  return highest;
}

int highestSignalFromThrustersFeedbackLoop(List<int> instructions) {
  final thrustersPermutations = Permutations(5, feedbackThrusters);
  var highest = 0;

  for (final permutation in thrustersPermutations()) {
    var inputs = List<int>();
    var lastOutput = 0;
    for (var input in permutation) {
      inputs.add(input);
      inputs.add(lastOutput);
      var outputs = diagnosticWithInput(instructions, inputs);
      lastOutput = outputs[outputs.length - 1];

      inputs = List<int>();
    }
    highest = max(highest, lastOutput);
  }
  return highest;
}

List<int> diagnosticWithInput(List<int> instructions, List<int> input) {
  var machine = IntCode(instructions, input = input);
  var success = machine.run();
  return success ? machine.output : [-1];
}
