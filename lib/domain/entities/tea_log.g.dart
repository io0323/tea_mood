// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tea_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeaLogAdapter extends TypeAdapter<TeaLog> {
  @override
  final int typeId = 0;

  @override
  TeaLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeaLog(
      id: fields[0] as String,
      teaType: fields[1] as String,
      caffeineMg: fields[2] as int,
      temperature: fields[3] as int,
      dateTime: fields[4] as DateTime,
      mood: fields[5] as String,
      amount: fields[6] as int,
      notes: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TeaLog obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.teaType)
      ..writeByte(2)
      ..write(obj.caffeineMg)
      ..writeByte(3)
      ..write(obj.temperature)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.mood)
      ..writeByte(6)
      ..write(obj.amount)
      ..writeByte(7)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeaLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
