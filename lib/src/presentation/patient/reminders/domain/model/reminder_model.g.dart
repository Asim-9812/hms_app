// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderModelAdapter extends TypeAdapter<ReminderModel> {
  @override
  final int typeId = 5;

  @override
  ReminderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderModel(
      medicineType: fields[0] as int,
      medicineName: fields[1] as String,
      strength: fields[2] as int,
      strengthUnitType: fields[3] as String,
      frequency: fields[4] as String,
      intakeTime: (fields[5] as List).cast<TimeOfDay>(),
      totalDays: fields[6] as int,
      startDate: fields[7] as DateTime,
      endDate: fields[8] as DateTime,
      medicineTime: fields[9] as String,
      reminderDuration: fields[10] as int,
      breakDuration: fields[11] as int,
      reminderImage: fields[12] as Uint8List?,
      reminderNote: fields[13] as String?,
      summary: fields[14] as String,
      createdDate: fields[15] as DateTime,
      daysOfWeek: (fields[16] as List?)?.cast<String>(),
      userId: fields[17] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ReminderModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.medicineType)
      ..writeByte(1)
      ..write(obj.medicineName)
      ..writeByte(2)
      ..write(obj.strength)
      ..writeByte(3)
      ..write(obj.strengthUnitType)
      ..writeByte(4)
      ..write(obj.frequency)
      ..writeByte(5)
      ..write(obj.intakeTime)
      ..writeByte(6)
      ..write(obj.totalDays)
      ..writeByte(7)
      ..write(obj.startDate)
      ..writeByte(8)
      ..write(obj.endDate)
      ..writeByte(9)
      ..write(obj.medicineTime)
      ..writeByte(10)
      ..write(obj.reminderDuration)
      ..writeByte(11)
      ..write(obj.breakDuration)
      ..writeByte(12)
      ..write(obj.reminderImage)
      ..writeByte(13)
      ..write(obj.reminderNote)
      ..writeByte(14)
      ..write(obj.summary)
      ..writeByte(15)
      ..write(obj.createdDate)
      ..writeByte(16)
      ..write(obj.daysOfWeek)
      ..writeByte(17)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
