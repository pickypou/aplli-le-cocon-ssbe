abstract class AddEvenementsState {}

class AddEvenementsSignUpInitialState extends AddEvenementsState {}

class AddEvenementsSignUpLoadingState extends AddEvenementsState {}

class AddEvenementsSignUpLoadedState extends AddEvenementsState {
  final Map<String, dynamic> evenementsData;
  AddEvenementsSignUpLoadedState({required this.evenementsData});
}

class AddEvenementsSignUpSuccessState extends AddEvenementsState {
  final String evenementId;
  AddEvenementsSignUpSuccessState({required this.evenementId});
}

class AddEvenementsSignUpErrorState extends AddEvenementsState {
  final String error;
  AddEvenementsSignUpErrorState({required this.error});

}
