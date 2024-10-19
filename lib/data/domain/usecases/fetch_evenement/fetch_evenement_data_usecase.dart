import 'package:app_lecocon_ssbe/data/domain/entity/evenement/evenements.dart';
import 'package:flutter/material.dart';
import '../../../repository/add_evenement_repository/evenement_repository.dart';


class FetchEvenementDataUseCase {
  final EvenementsRepository evenementsRepository;

  FetchEvenementDataUseCase(this.evenementsRepository);

  Future<List<Evenements>> getEvenement() async {
    try {
      debugPrint('Fetching evenement data');
      Stream<Iterable<Evenements>> evenementStream =
          evenementsRepository.getEvenementStream();

      List<Evenements> evenementList = [];
      await for (var evenementIterable in evenementStream) {
        evenementList.addAll(evenementIterable);
      }
      return evenementList;
    }catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Evenements?> getEvenementsById(String evenementId) async {
    try {
      debugPrint('Fetching evenement data from Firestore...');

      Map<String, dynamic>? evenementData =
          await evenementsRepository.getById(evenementId);
      return Evenements.fromMap(evenementData!, evenementId);
    }catch (e) {
      debugPrint('Error fetching evenement by ID : $e');
      rethrow;
    }
  }
}
