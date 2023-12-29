
import 'package:hive/hive.dart';

part 'calories_model.g.dart';

@HiveType(typeId: 40)
class AddFoodModel extends HiveObject {

  @HiveField(2)
  late String food;

  @HiveField(3)
  late double calories;

  AddFoodModel(this.food, this.calories);
}


@HiveType(typeId: 41)
class ActivitiesModel extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late int caloriesPerHour;

  @HiveField(2)
  late int durationMinutes;


  ActivitiesModel({
    required this.name,
    required this.caloriesPerHour,
    required this.durationMinutes,
  });

  factory ActivitiesModel.fromJson(Map<String, dynamic>? json) {
    return ActivitiesModel(
      name: json?['name'],
      caloriesPerHour: json?['calories_per_hour'],
      durationMinutes: json?['duration_minutes'],
    );
  }
}



@HiveType(typeId: 42)
class ActivityTypeModel {
  @HiveField(0)
  final int activityId;

  @HiveField(1)
  final String activityName;

  ActivityTypeModel({required this.activityId, required this.activityName});
}



@HiveType(typeId: 43)
class GoalTypeModel {
  @HiveField(0)
  final int goalId;

  @HiveField(1)
  final String goalName;

  GoalTypeModel({required this.goalId, required this.goalName});
}



@HiveType(typeId: 44)
class UserInfoCalories {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final int age;

  @HiveField(3)
  final int height;

  @HiveField(4)
  final int weight;

  @HiveField(5)
  final ActivityTypeModel activityIntensity;

  @HiveField(6)
  final GoalTypeModel goal;

  @HiveField(7)
  final int requiredCalories;

  @HiveField(8)
  final String gender;

  UserInfoCalories({
    required this.id,
    required this.userId,
    required this.age,
    required this.height,
    required this.weight,
    required this.activityIntensity,
    required this.goal,
    required this.requiredCalories,
    required this.gender,
  });
}

@HiveType(typeId: 45)
class CaloriesIntakeModel {
  @HiveField(0)
  final String food;

  @HiveField(1)
  final int caloriesPerServing;

  @HiveField(2)
  final int serving;

  @HiveField(3)
  final int caloriesIntake;

  CaloriesIntakeModel({
    required this.food,
    required this.caloriesPerServing,
    required this.serving,
    required this.caloriesIntake,
  });
}


@HiveType(typeId: 46)
class CaloriesBurnedModel {
  @HiveField(0)
  final String activityName;

  @HiveField(1)
  final int caloriesPerHour;

  @HiveField(2)
  final int duration;

  @HiveField(3)
  final int caloriesBurned;

  CaloriesBurnedModel({
    required this.activityName,
    required this.caloriesPerHour,
    required this.duration,
    required this.caloriesBurned,
  });
}

@HiveType(typeId: 47)
class CaloriesTrackingModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final int totalCalories;

  @HiveField(4)
  final int totalCaloriesIntake;

  @HiveField(5)
  final List<CaloriesIntakeModel> caloriesIntakeList;

  @HiveField(6)
  final int totalCaloriesBurned;

  @HiveField(7)
  final List<CaloriesBurnedModel> caloriesBurnedList;

  CaloriesTrackingModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.totalCalories,
    required this.totalCaloriesIntake,
    required this.caloriesIntakeList,
    required this.totalCaloriesBurned,
    required this.caloriesBurnedList,
  });
}

