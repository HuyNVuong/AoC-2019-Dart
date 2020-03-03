import 'dart:collection';
import 'dart:io';

void main(List<String> arguments) {
  File('data/04_secure_container.txt').readAsString().then((String contents) {
    var numberSequence = contents.split('-');
    print(numberSequence);
    print(findNumberOfPossiblePasswords(
        int.parse(numberSequence[0]), int.parse(numberSequence[1])));
    print(findNumberOfPossiblePasswordsWithNewRules(
        int.parse(numberSequence[0]), int.parse(numberSequence[1])));
  });
}

int findNumberOfPossiblePasswords(int lowerBound, int upperBound) {
  bool isNumberValid(int number) {
    var stringNumber = number.toString();
    var isDoubleDigit = false;
    for (var i = 0; i < stringNumber.length - 1; i++) {
      if (stringNumber[i] == stringNumber[i + 1]) {
        isDoubleDigit = true;
      } else if (int.parse(stringNumber[i]) > int.parse(stringNumber[i + 1])) {
        return false;
      }
    }
    return isDoubleDigit;
  }

  var n = 0;
  for (var i = lowerBound; i <= upperBound; i++) {
    if (isNumberValid(i)) {
      n++;
    }
  }
  return n;
}

int findNumberOfPossiblePasswordsWithNewRules(int lowerBound, int upperBound) {
  bool isNumberValid(int number) {
    var stringNumber = number.toString();
    var numberCount = HashMap<int, int>();
    for (var i = 0; i < stringNumber.length - 1; i++) {
      if (stringNumber[i] == stringNumber[i + 1]) {
        if (numberCount.containsKey(int.parse(stringNumber[i]))) {
          numberCount[int.parse(stringNumber[i])]++;
        } else {
          numberCount[int.parse(stringNumber[i])] = 2;
        }
      }
      if (int.parse(stringNumber[i]) > int.parse(stringNumber[i + 1])) {
        return false;
      }
    }

    for (var entry in numberCount.entries) {
      if (entry.value == 2) {
        return true;
      }
    }
    return false;
  }

  var n = 0;
  for (var i = lowerBound; i <= upperBound; i++) {
    if (isNumberValid(i)) {
      n++;
    }
  }
  return n;
}
