import 'package:app_lecocon_ssbe/data/repository/evenement_repository_impl.dart';
import 'package:app_lecocon_ssbe/domain/usecases/fetch_evenement_data_usecase.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/evenements.dart';

class EvenementListInteractor {
  final FetchEvenementDataUseCase fetchEvenementDataUseCase;
  final EvenementsRepositoryImpl evenementsRepositoryImpl;

  EvenementListInteractor(
    this.fetchEvenementDataUseCase,
    this.evenementsRepositoryImpl,
  );

  Future<Iterable<Evenements>> fetchEvenementData() async {
    try {
      final evenement = await fetchEvenementDataUseCase.getEvenement();
      return evenement;
    } catch (e) {
      debugPrint('Erreur lors de la récupération de l\'événement');
      rethrow;
    }
  }

  Future<Evenements?> getEvenementById(String evenementId) async {
    try {
      return await fetchEvenementDataUseCase.getEvenementsById(evenementId);
    } catch (e) {
      debugPrint('Erreur lors de la récupération de l\'événement par ID : $e');
      rethrow;
    }
  }

  Future<void> removeEvenement(String evenementId) async {
    try {
      await evenementsRepositoryImpl.deleteEvenement(evenementId);
      debugPrint('Événement supprimé : $evenementId');
    } catch (e) {
      debugPrint('Erreur lors de la suppression de l\'événement : $e');
      rethrow;
    }
  }
}
