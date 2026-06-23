// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_food_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomFoodModelAdapter extends TypeAdapter<CustomFoodModel> {
  @override
  final int typeId = 2;

  @override
  CustomFoodModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomFoodModel(
      id: fields[0] as String,
      name: fields[1] as String,
      calories: fields[2] as int,
      proteinG: fields[3] as double? ?? 0.0,
      carbsG: fields[4] as double? ?? 0.0,
      fatG: fields[5] as double? ?? 0.0,
      category: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomFoodModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.calories)
      ..writeByte(3)
      ..write(obj.proteinG)
      ..writeByte(4)
      ..write(obj.carbsG)
      ..writeByte(5)
      ..write(obj.fatG)
      ..writeByte(6)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomFoodModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
