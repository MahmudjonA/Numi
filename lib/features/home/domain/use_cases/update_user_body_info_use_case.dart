import 'package:numi/features/home/domain/repositories/user_body_repo.dart';
import '../entities/user_body_info.dart';

class UpdateUserBodyInfoUseCase {
  final UserBodyRepo userRepository;

  UpdateUserBodyInfoUseCase(this.userRepository);

  Future<void> call(UserBodyInfo bodyInfo) {
    return userRepository.updateUserBodyInfo(userBodyInfo: bodyInfo);
  }
}
