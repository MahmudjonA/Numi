// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealModelAdapter extends TypeAdapter<MealModel> {
  @override
  final int typeId = 0;

  @override
  MealModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealModel(
      id: fields[0] as String,
      name: fields[1] as String,
      calories: fields[2] as int,
      category: fields[3] as String,
      dateTime: fields[4] as DateTime,
      imagePath: fields[5] as String?,
      mealType: fields[6] as int? ?? 3,
      proteinG: fields[7] as double? ?? 0.0,
      carbsG: fields[8] as double? ?? 0.0,
      fatG: fields[9] as double? ?? 0.0,
      portionGrams: fields[10] as double?,
      isCustom: fields[11] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, MealModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.calories)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.imagePath)
      ..writeByte(6)
      ..write(obj.mealType)
      ..writeByte(7)
      ..write(obj.proteinG)
      ..writeByte(8)
      ..write(obj.carbsG)
      ..writeByte(9)
      ..write(obj.fatG)
      ..writeByte(10)
      ..write(obj.portionGrams)
      ..writeByte(11)
      ..write(obj.isCustom);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
