// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calorie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileModelAdapter extends TypeAdapter<UserProfileModel> {
  @override
  final int typeId = 1;

  @override
  UserProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileModel(
      date: fields[0] as DateTime,
      userId: fields[1] as String,
      username: fields[2] as String,
      age: fields[3] as int,
      weight: fields[4] as double,
      height: fields[5] as double,
      goalWeight: fields[6] as double,
      deadline: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.age)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.height)
      ..writeByte(6)
      ..write(obj.goalWeight)
      ..writeByte(7)
      ..write(obj.deadline);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyIntakeModelAdapter extends TypeAdapter<DailyIntakeModel> {
  @override
  final int typeId = 2;

  @override
  DailyIntakeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyIntakeModel(
      date: fields[0] as DateTime,
      totalCalorieIntake: fields[1] as double,
      goalCaloriesIntake: fields[2] as double,
      totalCalorieBurned: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DailyIntakeModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.totalCalorieIntake)
      ..writeByte(2)
      ..write(obj.goalCaloriesIntake)
      ..writeByte(3)
      ..write(obj.totalCalorieBurned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyIntakeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FoodDetailModelAdapter extends TypeAdapter<FoodDetailModel> {
  @override
  final int typeId = 3;

  @override
  FoodDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodDetailModel(
      date: fields[0] as DateTime,
      foodName: fields[1] as String,
      calories: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, FoodDetailModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.foodName)
      ..writeByte(2)
      ..write(obj.calories);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseModelAdapter extends TypeAdapter<ExerciseModel> {
  @override
  final int typeId = 4;

  @override
  ExerciseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseModel(
      date: fields[0] as DateTime,
      exerciseName: fields[1] as String,
      caloriesBurned: fields[2] as double,
      exerciseInterval: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.exerciseName)
      ..writeByte(2)
      ..write(obj.caloriesBurned)
      ..writeByte(3)
      ..write(obj.exerciseInterval);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
