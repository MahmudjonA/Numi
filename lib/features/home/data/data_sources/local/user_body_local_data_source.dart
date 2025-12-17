import '../../models/user_body_info_model.dart';

abstract class UserBodyLocalDataSource {
  Future<UserBodyInfoModel?> getUserBodyInfo();

  Future<void> saveUserBodyInfo({
    required UserBodyInfoModel userBodyInfo,
  });
}
