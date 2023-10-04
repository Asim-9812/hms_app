import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'reminder_model.g.dart';

@HiveType(typeId: 5)
class ReminderModel extends HiveObject {
  @HiveField(0)
  int medicineType;

  @HiveField(1)
  String medicineName;

  @HiveField(2)
  int strength;

  @HiveField(3)
  String strengthUnitType;

  @HiveField(4)
  String frequency;

  @HiveField(5)
  List<TimeOfDay> intakeTime;

  @HiveField(6)
  int totalDays;

  @HiveField(7)
  DateTime startDate;

  @HiveField(8)
  DateTime endDate;

  @HiveField(9)
  String medicineTime;

  @HiveField(10)
  int reminderDuration;

  @HiveField(11)
  int breakDuration;

  @HiveField(12)
  Uint8List? reminderImage;

  @HiveField(13)
  String? reminderNote;

  @HiveField(14)
  String summary;

  @HiveField(15)
  DateTime createdDate;

  @HiveField(16)
  List<String>? daysOfWeek;


  @HiveField(17)
  int userId;





  ReminderModel({
    required this.medicineType,
    required this.medicineName,
    required this.strength,
    required this.strengthUnitType,
    required this.frequency,
    required this.intakeTime,
    required this.totalDays,
    required this.startDate,
    required this.endDate,
    required this.medicineTime,
    required this.reminderDuration,
    required this.breakDuration,
    this.reminderImage,
    this.reminderNote,
    required this.summary,
    required this.createdDate,
    this.daysOfWeek,
    required this.userId,
  });
}
