

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MedicineTypeModel{
  final int id;
  final String name;
  final IconData icon;

  MedicineTypeModel({
    required this.id,
    required this.name,
    required this.icon
});
}

List<MedicineTypeModel> medicineType = [
  MedicineTypeModel(id: 1, name: 'Tablet', icon: FontAwesomeIcons.tablets),
  MedicineTypeModel(id: 2, name: 'Capsule', icon: FontAwesomeIcons.capsules),
  MedicineTypeModel(id: 3, name: 'Solution', icon: FontAwesomeIcons.glassWater),
  MedicineTypeModel(id: 4, name: 'Injection', icon: FontAwesomeIcons.syringe),
  MedicineTypeModel(id: 5, name: 'Drops', icon: FontAwesomeIcons.droplet),
  MedicineTypeModel(id: 6, name: 'Cream', icon: FontAwesomeIcons.handHoldingDroplet),
];


class StrengthModel{
  final int typeId;
  final String unitName;

  StrengthModel({
    required this.typeId,
    required this.unitName
});

}

List<StrengthModel> strengthType = [
  ///tablets...
  StrengthModel(typeId: 1, unitName: 'mg'),
  StrengthModel(typeId: 1, unitName: 'g'),
  StrengthModel(typeId: 1, unitName: 'IU'),
  StrengthModel(typeId: 1, unitName: 'mol'),
  StrengthModel(typeId: 1, unitName: 'mEq'),
  StrengthModel(typeId: 1, unitName: 'mCg'),

  ///capsules
  StrengthModel(typeId: 2, unitName: 'mg '),
  StrengthModel(typeId: 2, unitName: 'mCg'),

  ///solutions
  StrengthModel(typeId: 3, unitName: 'ml'),
  StrengthModel(typeId: 3, unitName: 'tsp'),
  StrengthModel(typeId: 3, unitName: 'tbsp'),
  StrengthModel(typeId: 3, unitName: 'drops'),
  StrengthModel(typeId: 3, unitName: 'L'),
  StrengthModel(typeId: 3, unitName: 'mg/ml'),
  StrengthModel(typeId: 3, unitName: 'mCg'),

  ///injections
  StrengthModel(typeId: 4, unitName: 'ml'),
  StrengthModel(typeId: 4, unitName: 'cc'),
  StrengthModel(typeId: 4, unitName: 'IU'),
  StrengthModel(typeId: 4, unitName: 'mg'),
  StrengthModel(typeId: 4, unitName: 'mCg'),
  StrengthModel(typeId: 4, unitName: 'ng'),
  StrengthModel(typeId: 4, unitName: 'U'),
  StrengthModel(typeId: 4, unitName: 'mol'),

  ///drops
  StrengthModel(typeId: 5, unitName: 'drops'),

  ///creams
  StrengthModel(typeId: 6, unitName: 'g'),
];


class FrequencyModel{
  final int id;
  final String frequencyName;
  final String frequencyInterval;

  FrequencyModel({
    required this.id,
    required this.frequencyName,
    required this.frequencyInterval
});
}

List<FrequencyModel> frequencyType = [
  FrequencyModel(id: 1, frequencyName: 'OD - Once a day', frequencyInterval: '24 hours interval'),
  FrequencyModel(id: 2, frequencyName: 'BDS - Twice a day', frequencyInterval: '12 hours interval'),
  FrequencyModel(id: 3, frequencyName: 'TDS - Thrice a day', frequencyInterval: '8 hours interval'),
  FrequencyModel(id: 4, frequencyName: 'QDS - Four times a day', frequencyInterval: '6 hours interval'),
];


List<String> mealInterval = ['','Before a Meal','After a Meal'];


class ReminderPatternModel{
  final int id;
  final String patternName;

  ReminderPatternModel({
    required this.id,
    required this.patternName
});

}

List<ReminderPatternModel> patternList = [
  ReminderPatternModel(id: 1, patternName: 'Everyday'),
  ReminderPatternModel(id: 2, patternName: 'Specific Days'),
  ReminderPatternModel(id: 3, patternName: 'Intervals (in days)'),
];


List<String> daysOfWeekMedication = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];

List<ReminderPatternModel> generalPatternList = [
  ReminderPatternModel(id: 1, patternName: 'Once'),
  ReminderPatternModel(id: 2, patternName: 'Everyday'),
  ReminderPatternModel(id: 3, patternName: 'Specific Days'),
  ReminderPatternModel(id: 4, patternName: 'Intervals (in days)'),
];


List<String> initialReminderType = ['min','hours','days'];