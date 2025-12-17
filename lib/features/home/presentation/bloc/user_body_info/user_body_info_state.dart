import 'package:numi/features/home/domain/entities/user_body_info.dart';

abstract class UserBodyInfoState {
  const UserBodyInfoState();
}

class UserBodyInfoInitial extends UserBodyInfoState {}

class UserBodyInfoLoading extends UserBodyInfoState {}

class UserBodyInfoLoaded extends UserBodyInfoState {
  final UserBodyInfo userBodyInfo;
  final int dailyCalories;

  const UserBodyInfoLoaded({
    required this.userBodyInfo,
    required this.dailyCalories,
  });
}

class UserBodyInfoEmpty extends UserBodyInfoState {}

class UserBodyInfoError extends UserBodyInfoState {
  final String message;

  const UserBodyInfoError({
    required this.message,
  });
}
