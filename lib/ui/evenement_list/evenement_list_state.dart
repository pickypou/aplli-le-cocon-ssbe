import 'package:app_lecocon_ssbe/domain/entity/evenements.dart';

abstract class EvenementListState {}

class EvenementsListSignUpInitialState extends EvenementListState {}

class EvenementsListSignUpLoadingState extends EvenementListState {}

class EvenementsListSignUpLoadState extends EvenementListState {
  final List<Evenements> evenementData;
  EvenementsListSignUpLoadState({required this.evenementData});
}

class EvenementsListSignUpSuccessState extends EvenementListState {
  final String evenementId;
  EvenementsListSignUpSuccessState({required this.evenementId});
}

class EvenementsListSignUpErrorState extends EvenementListState {
  final String error;
  EvenementsListSignUpErrorState({required this.error});
}
