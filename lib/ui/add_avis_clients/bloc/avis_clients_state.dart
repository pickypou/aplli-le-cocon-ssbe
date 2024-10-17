abstract class AddAvisClientsState {
  const AddAvisClientsState();
}

class AddAvisClientsSignUpInitialState extends AddAvisClientsState {}

class AddAvisClientsSignUpLoadingState extends AddAvisClientsState {}

class AddAvisClientsSignUpSuccessState extends AddAvisClientsState {
  final String addAvisClientsId;
  AddAvisClientsSignUpSuccessState({required this.addAvisClientsId});
}

class AddAvisClientsSignUpErrorState extends AddAvisClientsState {
  final String error;
  AddAvisClientsSignUpErrorState(this.error);
}