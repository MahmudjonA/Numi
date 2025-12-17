import 'package:hive/hive.dart';
import '../../domain/entities/user_body_info.dart';
part 'user_body_info_model.g.dart';

@HiveType(typeId: 1)
class UserBodyInfoModel extends HiveObject {
  @HiveField(0)
  final double weightKg;

  @HiveField(1)
  final double heightCm;

  @HiveField(2)
  final int age;

  @HiveField(3)
  final int gender; // enum index

  @HiveField(4)
  final int activityLevel; // enum index

  UserBodyInfoModel({
    required this.weightKg,
    required this.heightCm,
    required this.age,
    required this.gender,
    required this.activityLevel,
  });

  /// Model → Entity
  UserBodyInfo toEntity() {
    return UserBodyInfo(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      gender: Gender.values[gender],
      activityLevel: ActivityLevel.values[activityLevel],
    );
  }

  /// Entity → Model
  factory UserBodyInfoModel.fromEntity(UserBodyInfo entity) {
    return UserBodyInfoModel(
      weightKg: entity.weightKg,
      heightCm: entity.heightCm,
      age: entity.age,
      gender: entity.gender.index,
      activityLevel: entity.activityLevel.index,
    );
  }
}
