abstract class AddUserState {}

class AddUserSignUpInitialState extends AddUserState {}

class AddUserSignUpLoadingState extends AddUserState{}

class AddUserSignUpSuccessState extends AddUserState {
  final String userId;
  AddUserSignUpSuccessState({required this.userId});
}

class AddUserSignUpErrorState extends AddUserState {
  final String error;
  AddUserSignUpErrorState(this.error);
}

class AddUserSignUpFailureState extends AddUserState {}