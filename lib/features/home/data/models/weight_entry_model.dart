import 'package:hive/hive.dart';
import '../../domain/entities/weight_entry.dart';
part 'weight_entry_model.g.dart';

@HiveType(typeId: 3)
class WeightEntryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double weightKg;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final String? note;

  WeightEntryModel({
    required this.id,
    required this.weightKg,
    required this.dateTime,
    this.note,
  });

  factory WeightEntryModel.fromEntity(WeightEntry e) => WeightEntryModel(
        id: e.id,
        weightKg: e.weightKg,
        dateTime: e.dateTime,
        note: e.note,
      );

  WeightEntry toEntity() => WeightEntry(
        id: id,
        weightKg: weightKg,
        dateTime: dateTime,
        note: note,
      );
}
