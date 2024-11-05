import 'package:app_lecocon_ssbe/domain/entity/evenements.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'add_evenements_interator.dart';
import 'add_evenement_event.dart';
import 'add_evenement_state.dart';


class AddEvenementsBloc extends Bloc<AddEvenementEvent, AddEvenementsState> {
  final EvenementsInteractor evenementInteractor;

  AddEvenementsBloc(this.evenementInteractor )
      : super(AddEvenementsSignUpInitialState()) {
    on<AddEvenementEvent>((event, emit) async {
    if (event is AddEvenementSignUpEvent) {
      emit(AddEvenementsSignUpLoadingState());
      try {
        debugPrint('publishDate avant conversion: ${event.publishDate}');
        String fileUrl = await evenementInteractor.uploadFile(event.file);

        final evenement = Evenements(
            id: event.id,
            title: event.title,
            fileType: event.fileType,
            fileUrl: fileUrl,
            publishDate: event.publishDate,
            thumbnailUrl: event.thumbnail
        );
        await evenementInteractor.addEvenement(evenement);
        emit(AddEvenementsSignUpSuccessState(evenementId: event.id));
      }catch(error){
        emit(AddEvenementsSignUpErrorState(error:error.toString()));
      }
    }

    });
  }
}
