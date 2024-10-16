abstract class AddUserEvent {}

class AddUserSignUpEvent extends AddUserEvent {
  final String id;
  final String userName;
  final String email;
  final String password;

  AddUserSignUpEvent({
    required this.id,
    required this.userName,
    required this.email,
    required this.password
});
}
