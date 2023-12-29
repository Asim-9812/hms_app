// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calories_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddFoodModelAdapter extends TypeAdapter<AddFoodModel> {
  @override
  final int typeId = 40;

  @override
  AddFoodModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddFoodModel(
      fields[2] as String,
      fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, AddFoodModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(2)
      ..write(obj.food)
      ..writeByte(3)
      ..write(obj.calories);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddFoodModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActivitiesModelAdapter extends TypeAdapter<ActivitiesModel> {
  @override
  final int typeId = 41;

  @override
  ActivitiesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivitiesModel(
      name: fields[0] as String,
      caloriesPerHour: fields[1] as int,
      durationMinutes: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ActivitiesModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.caloriesPerHour)
      ..writeByte(2)
      ..write(obj.durationMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivitiesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActivityTypeModelAdapter extends TypeAdapter<ActivityTypeModel> {
  @override
  final int typeId = 42;

  @override
  ActivityTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityTypeModel(
      activityId: fields[0] as int,
      activityName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityTypeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.activityId)
      ..writeByte(1)
      ..write(obj.activityName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GoalTypeModelAdapter extends TypeAdapter<GoalTypeModel> {
  @override
  final int typeId = 43;

  @override
  GoalTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalTypeModel(
      goalId: fields[0] as int,
      goalName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GoalTypeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.goalId)
      ..writeByte(1)
      ..write(obj.goalName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserInfoCaloriesAdapter extends TypeAdapter<UserInfoCalories> {
  @override
  final int typeId = 44;

  @override
  UserInfoCalories read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserInfoCalories(
      id: fields[0] as int,
      userId: fields[1] as String,
      age: fields[2] as int,
      height: fields[3] as int,
      weight: fields[4] as int,
      activityIntensity: fields[5] as ActivityTypeModel,
      goal: fields[6] as GoalTypeModel,
      requiredCalories: fields[7] as int,
      gender: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserInfoCalories obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.height)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.activityIntensity)
      ..writeByte(6)
      ..write(obj.goal)
      ..writeByte(7)
      ..write(obj.requiredCalories)
      ..writeByte(8)
      ..write(obj.gender);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoCaloriesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CaloriesIntakeModelAdapter extends TypeAdapter<CaloriesIntakeModel> {
  @override
  final int typeId = 45;

  @override
  CaloriesIntakeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CaloriesIntakeModel(
      food: fields[0] as String,
      caloriesPerServing: fields[1] as int,
      serving: fields[2] as int,
      caloriesIntake: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CaloriesIntakeModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.food)
      ..writeByte(1)
      ..write(obj.caloriesPerServing)
      ..writeByte(2)
      ..write(obj.serving)
      ..writeByte(3)
      ..write(obj.caloriesIntake);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaloriesIntakeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CaloriesBurnedModelAdapter extends TypeAdapter<CaloriesBurnedModel> {
  @override
  final int typeId = 46;

  @override
  CaloriesBurnedModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CaloriesBurnedModel(
      activityName: fields[0] as String,
      caloriesPerHour: fields[1] as int,
      duration: fields[2] as int,
      caloriesBurned: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CaloriesBurnedModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.activityName)
      ..writeByte(1)
      ..write(obj.caloriesPerHour)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.caloriesBurned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaloriesBurnedModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CaloriesTrackingModelAdapter extends TypeAdapter<CaloriesTrackingModel> {
  @override
  final int typeId = 47;

  @override
  CaloriesTrackingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CaloriesTrackingModel(
      id: fields[0] as int,
      userId: fields[1] as String,
      date: fields[2] as String,
      totalCalories: fields[3] as int,
      totalCaloriesIntake: fields[4] as int,
      caloriesIntakeList: (fields[5] as List).cast<CaloriesIntakeModel>(),
      totalCaloriesBurned: fields[6] as int,
      caloriesBurnedList: (fields[7] as List).cast<CaloriesBurnedModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, CaloriesTrackingModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.totalCalories)
      ..writeByte(4)
      ..write(obj.totalCaloriesIntake)
      ..writeByte(5)
      ..write(obj.caloriesIntakeList)
      ..writeByte(6)
      ..write(obj.totalCaloriesBurned)
      ..writeByte(7)
      ..write(obj.caloriesBurnedList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaloriesTrackingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
