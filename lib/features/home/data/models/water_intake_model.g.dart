// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_intake_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WaterIntakeModelAdapter extends TypeAdapter<WaterIntakeModel> {
  @override
  final int typeId = 4;

  @override
  WaterIntakeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WaterIntakeModel(
      dateKey: fields[0] as String,
      totalMl: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WaterIntakeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.dateKey)
      ..writeByte(1)
      ..write(obj.totalMl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterIntakeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
