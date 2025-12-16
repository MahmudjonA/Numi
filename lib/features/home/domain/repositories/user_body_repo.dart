import 'package:numi/features/home/domain/entities/user_body_info.dart';

abstract class UserBodyRepo {
  Future<UserBodyInfo> getUserBodyInfo();

  Future<void> updateUserBodyInfo({required UserBodyInfo userBodyInfo});
}
