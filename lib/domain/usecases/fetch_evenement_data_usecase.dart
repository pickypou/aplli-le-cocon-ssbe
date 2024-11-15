import 'package:app_lecocon_ssbe/domain/entity/evenements.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../data/repository/evenement_repository.dart';

@injectable
class FetchEvenementDataUseCase {
  final EvenementsRepository evenementsRepository;

  FetchEvenementDataUseCase(this.evenementsRepository);

  // Méthode pour récupérer la liste des événements
  Future<List<Evenement>> getEvenement() async {
    try {
      debugPrint('Fetching evenement data');

      // Écoute du stream et ajout à une liste au fur et à mesure
      final evenementStream = evenementsRepository.getEvenementStream();
      final evenementList = await evenementStream.first;  // Récupérer tous les événements à la première émission du Stream

      return evenementList.toList();  // Retourner la liste
    } catch (e) {
      debugPrint('Error fetching evenement data: $e');
      rethrow;
    }
  }

  // Méthode pour récupérer un événement spécifique par son ID
  Future<Evenement?> getEvenementsById(String evenementId) async {
    try {
      debugPrint('Fetching evenement data from Firestore...');

      Map<String, dynamic>? evenementData = await evenementsRepository.getById(evenementId);
      if (evenementData == null) {
        debugPrint('No data found for evenementId: $evenementId');
        return null;
      }
      return Evenement.fromMap(evenementData, evenementId);
    } catch (e) {
      debugPrint('Error fetching evenement by ID: $e');
      rethrow;
    }
  }
}
