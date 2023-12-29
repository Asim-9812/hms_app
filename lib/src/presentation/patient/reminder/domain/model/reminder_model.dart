import 'dart:typed_data';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:hive/hive.dart';

part 'reminder_model.g.dart';

@HiveType(typeId: 20)
class Reminder {
  @HiveField(0)
  int reminderId;
  @HiveField(1)
  String userId;
  @HiveField(2)
  int medTypeId;
  @HiveField(3)
  String medTypeName;
  @HiveField(4)
  String medicineName;
  @HiveField(5)
  int strength;
  @HiveField(6)
  String unit;
  @HiveField(7)
  Frequency frequency;
  @HiveField(8)
  List<String> scheduleTime;
  @HiveField(9)
  int medicationDuration;
  @HiveField(10)
  DateTime startDate;
  @HiveField(11)
  DateTime endDate;
  @HiveField(12)
  int mealTypeId;
  @HiveField(13)
  String meal;
  @HiveField(14)
  ReminderPattern reminderPattern;
  @HiveField(15)
  Uint8List? reminderImage;
  @HiveField(16)
  String? notes;
  @HiveField(17)
  String summary;
  @HiveField(18)
  List<NotificationContent>? contentList;

  Reminder({
    required this.reminderId,
    required this.userId,
    required this.medTypeId,
    required this.medTypeName,
    required this.medicineName,
    required this.strength,
    required this.unit,
    required this.frequency,
    required this.scheduleTime,
    required this.medicationDuration,
    required this.startDate,
    required this.endDate,
    required this.mealTypeId,
    required this.meal,
    required this.reminderPattern,
    required this.reminderImage,
    required this.notes,
    required this.summary,
    this.contentList,
  });
}

@HiveType(typeId: 21)
class Frequency {
  @HiveField(0)
  int frequencyId;
  @HiveField(1)
  String frequencyName;
  @HiveField(2)
  String intervals;

  Frequency({
    required this.frequencyId,
    required this.frequencyName,
    required this.intervals,
  });
}

@HiveType(typeId: 22)
class ReminderPattern {
  @HiveField(0)
  int reminderPatternId;
  @HiveField(1)
  String patternName;
  @HiveField(2)
  int? interval;
  @HiveField(3)
  List<String>? daysOfWeek;

  ReminderPattern({
    required this.reminderPatternId,
    required this.patternName,
    this.interval,
    this.daysOfWeek,
  });
}
