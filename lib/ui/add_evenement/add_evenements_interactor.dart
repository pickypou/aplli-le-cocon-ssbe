import 'dart:io';
import 'package:app_lecocon_ssbe/core/di/api/firestore_service.dart';
import 'package:app_lecocon_ssbe/core/di/api/storage_service.dart';
import 'package:app_lecocon_ssbe/data/repository/evenement_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_lecocon_ssbe/domain/entity/evenements.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/usecases/fetch_evenement_data_usecase.dart';

class EvenementsInteractor {
  final EvenementsRepositoryImpl evenementsRepository;
  final FetchEvenementDataUseCase fetchEvenementDataUseCase;
  final StorageService _storageService;
  final FirestoreService _firestore;

  EvenementsInteractor(
      this.evenementsRepository,
      this.fetchEvenementDataUseCase,
      FirebaseStorage storage,
      FirebaseFirestore firestore, // Ajout de Firestore ici
      ) : _storageService = StorageService(storage),
        _firestore = FirestoreService(firestore); // Passer Firestore au constructeur de FirestoreService

  Future<Iterable<Evenements>> fetchEvenementData() async {
    try {
      final evenement = await fetchEvenementDataUseCase.getEvenement();
      return evenement;
    } catch (e) {
      debugPrint('Erreur lors de la récupération de l\'événement');
      rethrow;
    }
  }

  Future<String> uploadFile(File file) async {
    try {
      String fileName = file.path.split('/').last;
      Reference storageReference = _storageService.ref('evenement/$fileName');
      UploadTask uploadTask = storageReference.putFile(file);

      TaskSnapshot taskSnapshot = await uploadTask;
      String fileUrl = await taskSnapshot.ref.getDownloadURL();
      return fileUrl;
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi du fichier : $e');
    }
  }

  Future<void> addEvenement(Evenements evenement) async {
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
