// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_reminder_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicineReminderModelAdapter extends TypeAdapter<MedicineReminderModel> {
  @override
  final int typeId = 10;

  @override
  MedicineReminderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicineReminderModel(
      id: fields[0] as int,
      medicineType: fields[1] as MedicineType,
      strength: fields[2] as Strength,
      frequency: fields[3] as Frequency,
      scheduleTime: (fields[4] as List).cast<String>(),
      medicationDuration: fields[5] as int,
      startDate: fields[6] as String,
      endDate: fields[7] as String,
      meal: fields[8] as Meal,
      intervalPattern: fields[9] as IntervalPattern,
      intervalDuration: fields[10] as int?,
      daysOfWeek: (fields[11] as List?)?.cast<String>(),
      reminderImage: fields[12] as String?,
      summary: fields[13] as String,
      note: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MedicineReminderModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.medicineType)
      ..writeByte(2)
      ..write(obj.strength)
      ..writeByte(3)
      ..write(obj.frequency)
      ..writeByte(4)
      ..write(obj.scheduleTime)
      ..writeByte(5)
      ..write(obj.medicationDuration)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.endDate)
      ..writeByte(8)
      ..write(obj.meal)
      ..writeByte(9)
      ..write(obj.intervalPattern)
      ..writeByte(10)
      ..write(obj.intervalDuration)
      ..writeByte(11)
      ..write(obj.daysOfWeek)
      ..writeByte(12)
      ..write(obj.reminderImage)
      ..writeByte(13)
      ..write(obj.summary)
      ..writeByte(14)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineReminderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MedicineTypeAdapter extends TypeAdapter<MedicineType> {
  @override
  final int typeId = 11;

  @override
  MedicineType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicineType(
      medicineTypeId: fields[0] as int,
      medicineTypeName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MedicineType obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.medicineTypeId)
      ..writeByte(1)
      ..write(obj.medicineTypeName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StrengthAdapter extends TypeAdapter<Strength> {
  @override
  final int typeId = 12;

  @override
  Strength read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Strength(
      strengthDose: fields[0] as int,
      strengthUnit: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Strength obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.strengthDose)
      ..writeByte(1)
      ..write(obj.strengthUnit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StrengthAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FrequencyAdapter extends TypeAdapter<Frequency> {
  @override
  final int typeId = 13;

  @override
  Frequency read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Frequency(
      frequencyId: fields[0] as int,
      frequencyName: fields[1] as String,
      frequencyInterval: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Frequency obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.frequencyId)
      ..writeByte(1)
      ..write(obj.frequencyName)
      ..writeByte(2)
      ..write(obj.frequencyInterval);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrequencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealAdapter extends TypeAdapter<Meal> {
  @override
  final int typeId = 14;

  @override
  Meal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meal(
      mealId: fields[0] as int,
      mealTime: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Meal obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.mealId)
      ..writeByte(1)
      ..write(obj.mealTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IntervalPatternAdapter extends TypeAdapter<IntervalPattern> {
  @override
  final int typeId = 15;

  @override
  IntervalPattern read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IntervalPattern(
      intervalId: fields[0] as int,
      patternName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, IntervalPattern obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.intervalId)
      ..writeByte(1)
      ..write(obj.patternName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IntervalPatternAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
