import 'package:hive/hive.dart';
import '../../domain/entities/water_intake.dart';
part 'water_intake_model.g.dart';

@HiveType(typeId: 4)
class WaterIntakeModel extends HiveObject {
  @HiveField(0)
  final String dateKey;

  @HiveField(1)
  final int totalMl;

  WaterIntakeModel({required this.dateKey, required this.totalMl});

  factory WaterIntakeModel.fromEntity(WaterIntake e) =>
      WaterIntakeModel(dateKey: e.dateKey, totalMl: e.totalMl);

  WaterIntake toEntity() => WaterIntake(dateKey: dateKey, totalMl: totalMl);
}
