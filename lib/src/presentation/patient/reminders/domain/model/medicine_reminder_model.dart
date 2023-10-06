import 'package:hive/hive.dart';

part 'medicine_reminder_model.g.dart';

@HiveType(typeId: 10)
class MedicineReminderModel {
  @HiveField(0)
  int id;

  @HiveField(1)
  MedicineType medicineType;

  @HiveField(2)
  Strength strength;

  @HiveField(3)
  Frequency frequency;

  @HiveField(4)
  List<String> scheduleTime;

  @HiveField(5)
  int medicationDuration;

  @HiveField(6)
  String startDate;

  @HiveField(7)
  String endDate;

  @HiveField(8)
  Meal meal;

  @HiveField(9)
  IntervalPattern intervalPattern;

  @HiveField(10)
  int? intervalDuration;

  @HiveField(11)
  List<String>? daysOfWeek;

  @HiveField(12)
  String? reminderImage;

  @HiveField(13)
  String summary;

  @HiveField(14)
  String? note;

  MedicineReminderModel({
    required this.id,
    required this.medicineType,
    required this.strength,
    required this.frequency,
    required this.scheduleTime,
    required this.medicationDuration,
    required this.startDate,
    required this.endDate,
    required this.meal,
    required this.intervalPattern,
    this.intervalDuration,
    this.daysOfWeek,
    this.reminderImage,
    required this.summary,
    this.note,
  });

  factory MedicineReminderModel.fromJson(Map<String, dynamic> json) {
    return MedicineReminderModel(
      id: json['id'],
      medicineType: MedicineType.fromJson(json['medicineType']),
      strength: Strength.fromJson(json['strength']),
      frequency: Frequency.fromJson(json['frequency']),
      scheduleTime: List<String>.from(json['scheduleTime']),
      medicationDuration: json['medicationDuration'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      meal: Meal.fromJson(json['meal']),
      intervalPattern: IntervalPattern.fromJson(json['intervalPattern']),
      intervalDuration: json['intervalDuration'],
      daysOfWeek: List<String>.from(json['daysOfWeek']),
      reminderImage: json['reminderImage'],
      summary: json['summary'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['medicineType'] = this.medicineType.toJson();
    data['strength'] = this.strength.toJson();
    data['frequency'] = this.frequency.toJson();
    data['scheduleTime'] = this.scheduleTime;
    data['medicationDuration'] = this.medicationDuration;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['meal'] = this.meal.toJson();
    data['intervalPattern'] = this.intervalPattern.toJson();
    data['intervalDuration'] = this.intervalDuration;
    data['daysOfWeek'] = this.daysOfWeek;
    data['reminderImage'] = this.reminderImage;
    data['summary'] = this.summary;
    data['note'] = this.note;
    return data;
  }
}

@HiveType(typeId: 11)
class MedicineType {
  @HiveField(0)
  int medicineTypeId;

  @HiveField(1)
  String medicineTypeName;

  MedicineType({
    required this.medicineTypeId,
    required this.medicineTypeName,
  });

  factory MedicineType.fromJson(Map<String, dynamic> json) {
    return MedicineType(
      medicineTypeId: json['medicineTypeId'],
      medicineTypeName: json['medicineTypeName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['medicineTypeId'] = this.medicineTypeId;
    data['medicineTypeName'] = this.medicineTypeName;
    return data;
  }
}

@HiveType(typeId: 12)
class Strength {
  @HiveField(0)
  int strengthDose;

  @HiveField(1)
  String strengthUnit;

  Strength({
    required this.strengthDose,
    required this.strengthUnit,
  });

  factory Strength.fromJson(Map<String, dynamic> json) {
    return Strength(
      strengthDose: json['strengthDose'],
      strengthUnit: json['strengthUnit'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['strengthDose'] = this.strengthDose;
    data['strengthUnit'] = this.strengthUnit;
    return data;
  }
}

@HiveType(typeId: 13)
class Frequency {
  @HiveField(0)
  int frequencyId;

  @HiveField(1)
  String frequencyName;

  @HiveField(2)
  String frequencyInterval;

  Frequency({
    required this.frequencyId,
    required this.frequencyName,
    required this.frequencyInterval,
  });

  factory Frequency.fromJson(Map<String, dynamic> json) {
    return Frequency(
      frequencyId: json['frequencyId'],
      frequencyName: json['frequencyName'],
      frequencyInterval: json['frequencyInterval'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['frequencyId'] = this.frequencyId;
    data['frequencyName'] = this.frequencyName;
    data['frequencyInterval'] = this.frequencyInterval;
    return data;
  }
}

@HiveType(typeId: 14)
class Meal {
  @HiveField(0)
  int mealId;

  @HiveField(1)
  String mealTime;

  Meal({
    required this.mealId,
    required this.mealTime,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      mealId: json['mealId'],
      mealTime: json['mealTime'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['mealId'] = this.mealId;
    data['mealTime'] = this.mealTime;
    return data;
  }
}


@HiveType(typeId: 15)
class IntervalPattern {
  @HiveField(0)
  int intervalId;

  @HiveField(1)
  String patternName;

  IntervalPattern({
    required this.intervalId,
    required this.patternName,
  });

  factory IntervalPattern.fromJson(Map<String, dynamic> json) {
    return IntervalPattern(
      intervalId: json['intervalId'],
      patternName: json['patternName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['intervalId'] = this.intervalId;
    data['patternName'] = this.patternName;
    return data;
  }
}



