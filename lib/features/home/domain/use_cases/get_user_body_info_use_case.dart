import 'package:numi/features/home/domain/entities/user_body_info.dart';
import 'package:numi/features/home/domain/repositories/user_body_repo.dart';

class GetUserBodyInfoUseCase {
  UserBodyRepo userBodyRepo;

  GetUserBodyInfoUseCase(this.userBodyRepo);

  Future<UserBodyInfo?> call() {
    return userBodyRepo.getUserBodyInfo();
  }
}
