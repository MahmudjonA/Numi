import 'package:numi/features/home/data/data_sources/local/user_body_local_data_source.dart';
import 'package:numi/features/home/data/models/user_body_info_model.dart';
import 'package:numi/features/home/domain/entities/user_body_info.dart';
import 'package:numi/features/home/domain/repositories/user_body_repo.dart';

class UserBodyRepositoryImpl implements UserBodyRepo {
  final UserBodyLocalDataSource localDataSource;

  UserBodyRepositoryImpl(this.localDataSource);

  @override
  Future<UserBodyInfo?> getUserBodyInfo() async {
    final model = await localDataSource.getUserBodyInfo();

    if (model == null) return null;

    return model.toEntity();
  }

  @override
  Future<void> saveUserBodyInfo({required UserBodyInfo userBodyInfo}) async {
    final model = UserBodyInfoModel.fromEntity(userBodyInfo);

    await localDataSource.saveUserBodyInfo(userBodyInfo: model);
  }
}
