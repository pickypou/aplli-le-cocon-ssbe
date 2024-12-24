import 'package:flutter_bloc/flutter_bloc.dart';

import 'avis_clients_list_event.dart';
import 'avis_clients_list_interactor.dart';
import 'avis_clients_list_state.dart';

class AvisClientsListBloc
    extends Bloc<AvisClientsListEvent, AvisClientsListState> {
  final AvisClientsListInteractor avisClientListInteractor;
  final String avisClientsId;

  AvisClientsListBloc(this.avisClientListInteractor,
      {required this.avisClientsId})
      : super(AvisClientsListLoadingState() as AvisClientsListState);

  Stream<AvisClientsListState> mapEventToState(
      AvisClientsListEvent event) async* {
    if (event is AvisClientsListSignUpLoadState) {
      yield AvisClientsListLoadingState();
      try {
        final avisClients =
            await avisClientListInteractor.fetchAvisClientData();

        // Convertir l'itérable en une liste
        final avisClientsList = avisClients.toList();

        yield AvisClientsListSignUpLoadState(avisClientsData: avisClientsList);
      } catch (e) {
        yield AvisClientsListSignUpErrorState(
            error: 'Une erreur s\'est produite : $e');
      }
    }
  }
}
