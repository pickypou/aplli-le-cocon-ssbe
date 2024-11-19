
abstract class AddUserEvent {}

class AddUserSignUpEvent extends AddUserEvent {
  final String id;
  final String email;
  final String password;
  final String userName;
  final Function navigateToAccount;

  AddUserSignUpEvent({
    required this.id,
    required this.email,
    required this.password,
    required this.userName,
    required this.navigateToAccount
});
}