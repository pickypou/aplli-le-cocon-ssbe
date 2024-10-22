import 'package:flutter/material.dart';

import '../../../domain/entity/avis_clients.dart';
import '../../../domain/usecases/fetch_avis_clients_data_usecase.dart';
import '../../../data/repository/avis_client_repository.dart';




class AvisClientsInteractor {
  final FetchAvisClientDataUseCase fetchAvisClientDataUseCase;
  final AvisClientsRepository avisClientsRepository;

  AvisClientsInteractor(
      this.avisClientsRepository, this.fetchAvisClientDataUseCase
      );
  Future<Iterable<AvisClients>> fetchAvisClientsData() async {
    try {
      final avisClients = await fetchAvisClientDataUseCase.getAvisClients();
      return avisClients;
    }catch(e) {
      debugPrint('Erreur lors du récupération des avis clients : $e');
      rethrow;
    }
  }
  Future<void> addAvisClients(AvisClients avisClients) async {
    try {
      await avisClientsRepository.add({
        'categories': avisClients.categories,
        'text': avisClients.text,
        'publishDate': avisClients.publishDate
      });
    } catch (error) {
      debugPrint('Erreur lors de l\'ajout de l\'avis du client: $error');
      rethrow;
    }
  }

}