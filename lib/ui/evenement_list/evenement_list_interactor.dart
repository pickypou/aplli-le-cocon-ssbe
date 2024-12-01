import 'package:app_lecocon_ssbe/data/repository/evenement_repository_impl.dart';
import 'package:app_lecocon_ssbe/domain/usecases/fetch_evenement_data_usecase.dart';
import 'package:flutter/material.dart';

import '../../core/di/di.dart';
import '../../data/repository/evenement_repository.dart';
import '../../domain/entity/evenements.dart';

class EvenementListInteractor {
  final  fetchEvenementDataUseCase = getIt<FetchEvenementDataUseCase>();
  final  evenementsRepository = getIt<EvenementsRepository>();

  EvenementListInteractor(
  );

  Future<Iterable<Evenement>> fetchEvenementData() async {
    try {
      final evenement = await fetchEvenementDataUseCase.getEvenement();
      return evenement;
    } catch (e) {
      debugPrint('Erreur lors de la récupération de l\'événement');
      rethrow;
    }
  }

  Future<Evenement?> getEvenementById(String evenementId) async {
    try {
      return await fetchEvenementDataUseCase.getEvenementsById(evenementId);
    } catch (e) {
      debugPrint('Erreur lors de la récupération de l\'événement par ID : $e');
      rethrow;
    }
  }


  Future<void> removeEvenement(String evenementId) async {
    try {
      await evenementsRepository.deleteEvenement(evenementId, );
      debugPrint('Événement supprimé : $evenementId');
    } catch (e) {
      debugPrint('Erreur lors de la suppression de l\'événement : $e');
      rethrow;
    }
  }
}
