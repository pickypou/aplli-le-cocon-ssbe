import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_lecocon_ssbe/domain/entity/evenements.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../domain/usecases/fetch_evenement_data_usecase.dart';
import '../../../data/repository/evenement_repository.dart';

class EvenementsInteractor {
  final EvenementsRepository evenementsRepository;
  final FetchEvenementDataUseCase fetchEvenementDataUseCase;
  final FirebaseStorage _firebaseStorage;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EvenementsInteractor(
      this.evenementsRepository, this.fetchEvenementDataUseCase, this._firebaseStorage);

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
      Reference storageReference = _firebaseStorage.ref().child('evenements/$fileName');
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
      await _firestore.collection('evenements').add({
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
