// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_body_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserBodyInfoModelAdapter extends TypeAdapter<UserBodyInfoModel> {
  @override
  final int typeId = 1;

  @override
  UserBodyInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserBodyInfoModel(
      weightKg: fields[0] as double,
      heightCm: fields[1] as double,
      age: fields[2] as int,
      gender: fields[3] as int,
      activityLevel: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserBodyInfoModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.weightKg)
      ..writeByte(1)
      ..write(obj.heightCm)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.activityLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserBodyInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
