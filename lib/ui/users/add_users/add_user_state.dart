abstract class AddUserState {}

class SignUpInitialState extends AddUserState {}

class SignUpLoadingState extends AddUserState {}

class SignUpSuccessState extends AddUserState {
  final String userId;
  SignUpSuccessState({required this.userId});
}

class SignUpErrorState extends AddUserState {
  final String error;

  SignUpErrorState(this.error);
}

class SignUpFailureState extends AddUserState {}