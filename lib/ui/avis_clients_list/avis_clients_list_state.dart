import 'package:app_lecocon_ssbe/domain/entity/avis_clients.dart';

abstract class AvisClientsListState {}

class AvisClientsListSignUpInitial extends AvisClientsListState {}

class AvisClientsListLoadingState extends AvisClientsListState {}

class AvisClientsListSignUpLoadState extends AvisClientsListState {
  final List<AvisClients> avisClientsData;
  AvisClientsListSignUpLoadState({required this.avisClientsData});
}

class AvisClientsListSignUpSuccessState extends AvisClientsListState {
  final String avisClientListId;
  AvisClientsListSignUpSuccessState({required this.avisClientListId});
}

class AvisClientsListSignUpErrorState extends AvisClientsListState {
  final String error;
  AvisClientsListSignUpErrorState({required this.error});
}
