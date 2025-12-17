import 'package:numi/features/home/domain/repositories/user_body_repo.dart';
import '../entities/user_body_info.dart';

class SaveUserBodyInfoUseCase {
  final UserBodyRepo userRepository;

  SaveUserBodyInfoUseCase(this.userRepository);

  Future<void> call(UserBodyInfo bodyInfo) {
    return userRepository.saveUserBodyInfo(userBodyInfo: bodyInfo);
  }
}
