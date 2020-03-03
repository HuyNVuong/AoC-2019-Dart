enum Opcode { add, multiply }

class IntCode {
  List<int> instructions;
  List<int> output;
  int input;

  IntCode(List<int> instructions, [input = 0]) {
    this.instructions = instructions;
    this.input = input;
    output = <int>[];
  }

  bool run() {
    var i = 0;
    int getValue(int position, int mode) {
      if (mode == 0) {
        return instructions[instructions[position]];
      } else {
        return instructions[position];
      }
    }

    while (instructions[i] % 100 != 99) {
      try {
        var secondParamMode = (instructions[i] ~/ 1000) % 10;
        var firstParamMode = (instructions[i] ~/ 100) % 10;
        var instruction = instructions[i] % 10;
        if (instruction == 1) {
          var a = getValue(i + 1, firstParamMode);
          var b = getValue(i + 2, secondParamMode);
          instructions[instructions[i + 3]] = a + b;
          i += 4;
        } else if (instruction == 2) {
          var a = getValue(i + 1, firstParamMode);
          var b = getValue(i + 2, secondParamMode);
          instructions[instructions[i + 3]] = a * b;
          i += 4;
        } else if (instruction == 3) {
          var address = instructions[i + 1];
          instructions[address] = input;
          i += 2;
        } else if (instruction == 4) {
          output.add(getValue(i + 1, firstParamMode));
          i += 2;
        } else if (instruction == 5) {
          var source = getValue(i + 1, firstParamMode);
          var destination = getValue(i + 2, secondParamMode);
          if (source != 0) {
            i = destination;
          } else {
            i += 3;
          }
        } else if (instruction == 6) {
          var source = getValue(i + 1, firstParamMode);
          var destination = getValue(i + 2, secondParamMode);
          if (source == 0) {
            i = destination;
          } else {
            i += 3;
          }
        } else if (instruction == 7) {
          var a = getValue(i + 1, firstParamMode);
          var b = getValue(i + 2, secondParamMode);
          instructions[instructions[i + 3]] = a < b ? 1 : 0;
          i += 4;
        } else if (instruction == 8) {
          var a = getValue(i + 1, firstParamMode);
          var b = getValue(i + 2, secondParamMode);
          instructions[instructions[i + 3]] = a == b ? 1 : 0;
          i += 4;
        }
      } on Exception {
        return false;
      }
    }
    return true;
  }
}

class Point {
  int x;
  int y;

  Point(x, y) {
    this.x = x;
    this.y = y;
  }

  int manhattanDistance(Point other) {
    return (x - other.x).abs() + (y - other.y).abs();
  }

  @override
  String toString() {
    return 'Point(${x},${y})';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Point && x == other.x && y == other.y;

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + x.hashCode;
    result = 37 * result + y.hashCode;
    return result;
  }
}
