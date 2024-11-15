import 'package:app_lecocon_ssbe/ui/evenement_list/evenement_list_event.dart';
import 'package:app_lecocon_ssbe/ui/evenement_list/evenement_list_interactor.dart';
import 'package:app_lecocon_ssbe/ui/evenement_list/evenement_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EvenementListBloc extends Bloc<EvenementListEvent, EvenementListState> {
  final EvenementListInteractor evenementListInteractor;
  final String evenementId;

  EvenementListBloc(this.evenementListInteractor, {required this.evenementId})
      : super(EvenementsListSignUpLoadingState());

  Stream<EvenementListState> mapEventToState(EvenementListEvent event) async* {
    if (event is LoadEvenementList) {
      yield EvenementsListSignUpLoadingState();
      try {
        final evenement = await evenementListInteractor.fetchEvenementData();

        // Convertir l'itérable en une liste
        final evenementList = evenement.toList();

        yield EvenementsListSignUpLoadState(evenementData: evenementList);
      } catch (e) {
        yield EvenementsListSignUpErrorState(
            error: 'Une erreur s\'est produite : $e');
      }
    }
  }
}
