import 'package:hive/hive.dart';
import '../../../domain/entities/user_body_info.dart';
import '../../models/user_body_info_model.dart';
import 'user_body_local_data_source.dart';
import '../../../../../core/logger.dart';

class UserBodyLocalDataSourceImpl implements UserBodyLocalDataSource {
  static const String _boxName = 'user_body';
  static const String _key = 'user_body_info';

  Box<UserBodyInfoModel> get _box => Hive.box<UserBodyInfoModel>(_boxName);

  @override
  Future<UserBodyInfoModel?> getUserBodyInfo() async {
    try {
      LoggerService.info('📦 [Hive] Fetching user body info...');

      final bodyInfo = _box.get(_key);

      if (bodyInfo == null) {
        LoggerService.warning('⚠️ [Hive] No user body info found');
        return null;
      }

      LoggerService.debug(
        '✅ [Hive] User body info loaded '
        '(weight=${bodyInfo.weightKg}, height=${bodyInfo.heightCm})',
      );

      return bodyInfo;
    } catch (e) {
      LoggerService.error(
        '❌ [Hive] Failed to fetch user body info | Error: $e',
      );
      rethrow;
    }
  }

  @override
  Future<void> saveUserBodyInfo({
    required UserBodyInfoModel userBodyInfo,
  }) async {
    try {
      LoggerService.info(
        '📦 [Hive] Saving user body info '
        '(weight=${userBodyInfo.weightKg}, '
        'height=${userBodyInfo.heightCm}, '
        'age=${userBodyInfo.age}, '
        'gender=${Gender.values[userBodyInfo.gender]}, '
        'activity=${ActivityLevel.values[userBodyInfo.activityLevel]})',
      );

      await _box.put(_key, userBodyInfo);

      LoggerService.debug('✅ [Hive] User body info saved successfully');
    } catch (e) {
      LoggerService.error('❌ [Hive] Failed to save user body info | Error: $e');
      rethrow;
    }
  }
}
