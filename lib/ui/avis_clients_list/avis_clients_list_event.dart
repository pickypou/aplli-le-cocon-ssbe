import 'package:equatable/equatable.dart';

abstract class AvisClientsListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadAvisClientsList extends AvisClientsListEvent {}

class FetchComFetchAvisClientsListDetail extends AvisClientsListEvent {
  final String avisClientsListId;
  FetchComFetchAvisClientsListDetail(this.avisClientsListId);

  @override
  List<Object> get props => [avisClientsListId];
}
