import 'package:equatable/equatable.dart';

abstract class EvenementListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadEvenementList extends EvenementListEvent {}

class FetchComFetchEvenementListDetail extends EvenementListEvent {
  final String evenementId;

  FetchComFetchEvenementListDetail(this.evenementId);

  @override
  List<Object> get props => [evenementId];
}
