// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 20;

  @override
  Reminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reminder(
      reminderId: fields[0] as int,
      userId: fields[1] as String,
      medTypeId: fields[2] as int,
      medTypeName: fields[3] as String,
      medicineName: fields[4] as String,
      strength: fields[5] as double,
      unit: fields[6] as String,
      frequency: fields[7] as Frequency,
      scheduleTime: (fields[8] as List).cast<String>(),
      medicationDuration: fields[9] as int,
      startDate: fields[10] as DateTime,
      endDate: fields[11] as DateTime,
      mealTypeId: fields[12] as int,
      meal: fields[13] as String,
      reminderPattern: fields[14] as ReminderPattern,
      reminderImage: fields[15] as Uint8List?,
      notes: fields[16] as String?,
      summary: fields[17] as String,
      contentId: fields[18] as int,
      dateList: (fields[19] as List).cast<DateListModel>(),
      reminderTypeId: fields[20] as int,
      initialContentId: fields[21] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.reminderId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.medTypeId)
      ..writeByte(3)
      ..write(obj.medTypeName)
      ..writeByte(4)
      ..write(obj.medicineName)
      ..writeByte(5)
      ..write(obj.strength)
      ..writeByte(6)
      ..write(obj.unit)
      ..writeByte(7)
      ..write(obj.frequency)
      ..writeByte(8)
      ..write(obj.scheduleTime)
      ..writeByte(9)
      ..write(obj.medicationDuration)
      ..writeByte(10)
      ..write(obj.startDate)
      ..writeByte(11)
      ..write(obj.endDate)
      ..writeByte(12)
      ..write(obj.mealTypeId)
      ..writeByte(13)
      ..write(obj.meal)
      ..writeByte(14)
      ..write(obj.reminderPattern)
      ..writeByte(15)
      ..write(obj.reminderImage)
      ..writeByte(16)
      ..write(obj.notes)
      ..writeByte(17)
      ..write(obj.summary)
      ..writeByte(18)
      ..write(obj.contentId)
      ..writeByte(19)
      ..write(obj.dateList)
      ..writeByte(20)
      ..write(obj.reminderTypeId)
      ..writeByte(21)
      ..write(obj.initialContentId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FrequencyAdapter extends TypeAdapter<Frequency> {
  @override
  final int typeId = 21;

  @override
  Frequency read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Frequency(
      frequencyId: fields[0] as int,
      frequencyName: fields[1] as String,
      intervals: fields[2] as String,
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
      ..write(obj.intervals);
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

class ReminderPatternAdapter extends TypeAdapter<ReminderPattern> {
  @override
  final int typeId = 22;

  @override
  ReminderPattern read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderPattern(
      reminderPatternId: fields[0] as int,
      patternName: fields[1] as String,
      interval: fields[2] as int?,
      daysOfWeek: (fields[3] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ReminderPattern obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.reminderPatternId)
      ..writeByte(1)
      ..write(obj.patternName)
      ..writeByte(2)
      ..write(obj.interval)
      ..writeByte(3)
      ..write(obj.daysOfWeek);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderPatternAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DateListModelAdapter extends TypeAdapter<DateListModel> {
  @override
  final int typeId = 23;

  @override
  DateListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DateListModel(
      dateId: fields[0] as int,
      reminderDate: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DateListModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.dateId)
      ..writeByte(1)
      ..write(obj.reminderDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
