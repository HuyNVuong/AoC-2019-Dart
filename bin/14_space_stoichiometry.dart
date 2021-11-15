import 'dart:collection';
import 'dart:io';

class ChemicalSubstance {
  String name;
  double consume;
  double multiplier;

  ChemicalSubstance(String name, double consume, [multiplier = 0.0]) {
    this.name = name;
    this.consume = consume;
    this.multiplier = multiplier;
  }

  @override
  String toString() {
    return 'ChemicalSubtance(${name}, ${consume})';
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is ChemicalSubstance && this.name == other.name;

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + name.hashCode;
    return result;
  }
}

void main(List<String> arguments) {
  File('data/14_space_stoichiometry.txt').readAsString().then((String contents) {
    var lines = contents.split('\n');
    var fuelRequirement = <ChemicalSubstance, List<ChemicalSubstance>>{};
    for (var line in lines) {
      var reactions = line.split(' => ');
      var substance = reactions[1].split(' ');
      var compounds = reactions[0].split(', ');
      fuelRequirement.putIfAbsent(ChemicalSubstance(substance[1].trim(), double.parse(substance[0])), () => <ChemicalSubstance>[]);
      for (var compound in compounds) {
        var compoundSubstance = compound.split(' ');
        fuelRequirement[ChemicalSubstance(substance[1].trim(), double.parse(substance[0]))].add(ChemicalSubstance(compoundSubstance[1], double.parse(compoundSubstance[0])));
      }
    }
    print(findNumberOfOresForFuel(fuelRequirement));
  });
}

double findNumberOfOresForFuel(Map<ChemicalSubstance, List<ChemicalSubstance>> fuelRequirement) {
  var queue = Queue<ChemicalSubstance>();
  var oresNeeded = 0.0;
  queue.add(ChemicalSubstance('FUEL', 1));
  var requiredMultiplier = <String, double>{};
  while (!queue.isEmpty) {
    var substance = queue.removeLast();
    if (!fuelRequirement.containsKey(substance)) {
      continue;
    }
    var fuelCompounds = fuelRequirement[substance];
    var compoundIngredient = fuelRequirement.keys.firstWhere((x) => x == substance, orElse: null);
    print(compoundIngredient);
    var multiplier = substance.consume / compoundIngredient.consume;
    print(multiplier);
    for (var fuelCompound in fuelCompounds) {
      queue.add(ChemicalSubstance(fuelCompound.name, fuelCompound.consume * multiplier));
    }
  }

  requiredMultiplier.forEach((key, value) => {
    oresNeeded += fuelRequirement[ChemicalSubstance(key, 0)][0].consume * value.ceil()
  });

  return oresNeeded;
}