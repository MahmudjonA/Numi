import 'package:numi/features/home/domain/entities/user_body_info.dart';

abstract class UserBodyInfoEvent {
  const UserBodyInfoEvent();
}

/// Load saved user body info
class LoadUserBodyInfoEvent extends UserBodyInfoEvent {}

/// Save / Update user body info
class SaveUserBodyInfoEvent extends UserBodyInfoEvent {
  final UserBodyInfo userBodyInfo;

  const SaveUserBodyInfoEvent({
    required this.userBodyInfo,
  });
}
