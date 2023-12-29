// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 31;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      taskId: fields[0] as int,
      userId: fields[1] as String,
      taskName: fields[2] as String,
      taskDesc: fields[3] as String?,
      priorityLevel: fields[4] as String,
      createdDate: fields[5] as String,
      remindMe: fields[6] as bool,
      remindDate: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.taskId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.taskName)
      ..writeByte(3)
      ..write(obj.taskDesc)
      ..writeByte(4)
      ..write(obj.priorityLevel)
      ..writeByte(5)
      ..write(obj.createdDate)
      ..writeByte(6)
      ..write(obj.remindMe)
      ..writeByte(7)
      ..write(obj.remindDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
