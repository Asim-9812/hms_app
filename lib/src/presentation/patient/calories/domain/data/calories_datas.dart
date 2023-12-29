



import 'package:meroupachar/src/presentation/patient/calories/domain/model/calories_model.dart';

List<ActivityTypeModel> activityLevelList = [
  ActivityTypeModel(activityId: 0, activityName: 'None'),
  ActivityTypeModel(activityId: 1, activityName: 'Low'),
  ActivityTypeModel(activityId: 2, activityName: 'Moderate'),
  ActivityTypeModel(activityId: 3, activityName: 'High'),
  ActivityTypeModel(activityId: 4, activityName: 'Very High')
];


List<GoalTypeModel> goalList = [
  GoalTypeModel(goalId: 0, goalName: 'Lose'),
  GoalTypeModel(goalId: 1, goalName: 'Maintain'),
  GoalTypeModel(goalId: 2, goalName: 'Gain')
];



List<Map<String,dynamic>> CaloriesIntakeList = [
  {
    'id' : 1001,
    'userId' : 'DOC001',
    'date' : '2023-08-07',
    'totalCalories' : 2400,
    'totalCaloriesIntake' : 2600,
    'caloriesIntakeList' : [
      CaloriesIntakeModel(food: 'food', caloriesPerServing: 240, serving: 2, caloriesIntake: 480)
    ],
    'totalCaloriesBurned' : 200,
    'caloriesBurnedList' : [
      CaloriesBurnedModel(activityName: 'activityName', caloriesPerHour: 240, duration: 60, caloriesBurned: 240)
    ]
    
  }
];