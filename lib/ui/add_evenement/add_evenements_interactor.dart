import 'dart:typed_data';

import 'package:app_lecocon_ssbe/core/di/api/firestore_service.dart';
import 'package:app_lecocon_ssbe/core/di/api/storage_service.dart';
import 'package:app_lecocon_ssbe/domain/entity/evenements.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../data/repository/evenement_repository.dart';
import '../../domain/usecases/fetch_evenement_data_usecase.dart';

class EvenementsInteractor {
  final EvenementsRepository evenementsRepository;
  final FetchEvenementDataUseCase fetchEvenementDataUseCase;
  final StorageService _storageService;
  final FirestoreService _firestore;

  EvenementsInteractor(
    this.evenementsRepository,
    this.fetchEvenementDataUseCase,
    FirebaseStorage storage,
    FirebaseFirestore firestore, // Ajout de Firestore ici
  )   : _storageService = StorageService(storage),
        _firestore = FirestoreService(
            firestore); // Passer Firestore au constructeur de FirestoreService

  Future<Iterable<Evenement>> fetchEvenementData() async {
    try {
      final evenement = await fetchEvenementDataUseCase.getEvenement();
      return evenement;
    } catch (e) {
      debugPrint('Erreur lors de la récupération de l\'événement');
      rethrow;
    }
  }

  Future<String> uploadFileFromBytes(
      Uint8List fileBytes, String fileName) async {
    try {
      // Référence de stockage où le fichier sera uploadé
      Reference storageReference = _storageService.ref('evenement/$fileName');

      // Upload des données binaires (Web)
      UploadTask uploadTask = storageReference.putData(fileBytes);

      // Attendre que l'upload soit terminé
      TaskSnapshot taskSnapshot = await uploadTask;

      // Une fois l'upload terminé, obtenir l'URL de téléchargement du fichier
      String fileUrl = await taskSnapshot.ref.getDownloadURL();

      debugPrint('Fichier téléchargé avec succès ! URL : $fileUrl');
      return fileUrl;
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi du fichier : $e');
    }
  }

  Future<void> addEvenement(Evenement evenement) async {
    try {
      await _firestore.collection('evenement').add({
        'title': evenement.title,
        'fileUrl': evenement.fileUrl,
        'fileType': evenement.fileType,
        'publishDate': evenement.publishDate,
      });
    } catch (e) {
      debugPrint('Erreur lors de l\'ajout de l\'événement: $e');
      throw Exception('Erreur lors de l\'ajout de l\'événement: $e');
    }
  }
}
