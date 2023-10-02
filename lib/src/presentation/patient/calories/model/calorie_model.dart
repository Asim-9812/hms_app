// calorie_model.g.dart
import 'package:hive/hive.dart';

part 'calorie_model.g.dart';

@HiveType(typeId: 1)
class UserProfileModel extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String username;

  @HiveField(3)
  final int age;

  @HiveField(4)
  final double weight;

  @HiveField(5)
  final double height;

  @HiveField(6)
  final double goalWeight;

  @HiveField(7)
  final DateTime deadline;

  UserProfileModel({
    required this.date,
    required this.userId,
    required this.username,
    required this.age,
    required this.weight,
    required this.height,
    required this.goalWeight,
    required this.deadline,
  });
}

@HiveType(typeId: 2)
class DailyIntakeModel extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final double totalCalorieIntake;

  @HiveField(2)
  final double goalCaloriesIntake;

  @HiveField(3)
  final double totalCalorieBurned;

  DailyIntakeModel({
    required this.date,
    required this.totalCalorieIntake,
    required this.goalCaloriesIntake,
    required this.totalCalorieBurned,
  });
}

@HiveType(typeId: 3)
class FoodDetailModel extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final String foodName;

  @HiveField(2)
  final double calories;

  FoodDetailModel({
    required this.date,
    required this.foodName,
    required this.calories,
  });
}

@HiveType(typeId: 4)
class ExerciseModel extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final String exerciseName;

  @HiveField(2)
  final double caloriesBurned;

  @HiveField(3)
  final double exerciseInterval;

  ExerciseModel({
    required this.date,
    required this.exerciseName,
    required this.caloriesBurned,
    required this.exerciseInterval,
  });
}
