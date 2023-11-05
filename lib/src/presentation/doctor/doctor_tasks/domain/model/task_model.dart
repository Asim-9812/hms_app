


import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 31)
class TaskModel {
  @HiveField(0)
  final int taskId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String taskName;

  @HiveField(3)
  final String? taskDesc;

  @HiveField(4)
  final String priorityLevel;

  @HiveField(5)
  final String createdDate;

  @HiveField(6)
  final bool remindMe;

  @HiveField(7)
  final String? remindDate;

  TaskModel({
    required this.taskId,
    required this.userId,
    required this.taskName,
    this.taskDesc,
    required this.priorityLevel,
    required this.createdDate,
    required this.remindMe,
    this.remindDate
  });
}
