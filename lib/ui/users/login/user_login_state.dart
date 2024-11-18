// user_state.dart

abstract class UserLoginState {}

class UserLoginInitial extends UserLoginState {}

class UserLoginLoading extends UserLoginState {}

class UserLoginSuccess extends UserLoginState {}

class LoginFailure extends UserLoginState {
  final String error;

  LoginFailure({required this.error});
}

class PasswordResetInProgress extends UserLoginState {}

class PasswordResetSuccess extends UserLoginState {}

class PasswordResetFailure extends UserLoginState {
  final String error;

  PasswordResetFailure({required this.error});
}
class AuthenticationErrorState extends UserLoginState {}

class UserDataLoadedState extends UserLoginState {
  final Map<String, dynamic> userData;
  UserDataLoadedState( this.userData);
}

