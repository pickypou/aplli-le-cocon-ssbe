abstract class UserLoginEvent {}

class FetchUserDataEvent extends UserLoginEvent {}


class LoginWithEmailPassword extends UserLoginEvent {
  final String email;
  final String password;
  final Function navigateToAccount;

  LoginWithEmailPassword(
      {required this.email,
        required this.password,
        required this.navigateToAccount});
}

class ResetPasswordRequested extends UserLoginEvent {
  final String email;

  ResetPasswordRequested({required this.email});
}

class LogOutEvent extends UserLoginEvent {}
