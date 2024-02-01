// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_reminder_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeneralReminderModelAdapter extends TypeAdapter<GeneralReminderModel> {
  @override
  final int typeId = 10;

  @override
  GeneralReminderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeneralReminderModel(
      reminderId: fields[0] as int,
      title: fields[1] as String,
      description: fields[2] as String,
      time: fields[3] as String,
      startDate: fields[4] as DateTime,
      initialReminder: fields[5] as InitialReminder?,
      reminderPattern: fields[6] as ReminderPattern,
      userId: fields[7] as String,
      contentId: fields[8] as int,
      reminderTypeId: fields[9] as int,
      initialContentId: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, GeneralReminderModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.reminderId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.initialReminder)
      ..writeByte(6)
      ..write(obj.reminderPattern)
      ..writeByte(7)
      ..write(obj.userId)
      ..writeByte(8)
      ..write(obj.contentId)
      ..writeByte(9)
      ..write(obj.reminderTypeId)
      ..writeByte(10)
      ..write(obj.initialContentId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralReminderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InitialReminderAdapter extends TypeAdapter<InitialReminder> {
  @override
  final int typeId = 11;

  @override
  InitialReminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InitialReminder(
      initialReminderTypeId: fields[0] as int,
      initialReminderTypeName: fields[1] as String,
      initialReminder: fields[2] as int,
      initialReminderContentId: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, InitialReminder obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.initialReminderTypeId)
      ..writeByte(1)
      ..write(obj.initialReminderTypeName)
      ..writeByte(2)
      ..write(obj.initialReminder)
      ..writeByte(3)
      ..write(obj.initialReminderContentId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InitialReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
