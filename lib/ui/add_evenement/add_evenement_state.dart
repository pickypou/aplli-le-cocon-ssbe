abstract class AddEvenementsState {}

class AddEvenementsSignUpInitialState extends AddEvenementsState {}

class AddEvenementsSignUpLoadingState extends AddEvenementsState {}

class AddEvenementsSignUpSuccessState extends AddEvenementsState {
  final String evenementId;
  AddEvenementsSignUpSuccessState({required this.evenementId});
}

class AddEvenementsSignUpErrorState extends AddEvenementsState {
  final String error;
  AddEvenementsSignUpErrorState({required this.error});
}
