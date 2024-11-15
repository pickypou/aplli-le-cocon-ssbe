import 'package:app_lecocon_ssbe/core/di/api/firestore_service.dart';
import 'package:app_lecocon_ssbe/core/di/api/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/evenements.dart';
import '../dto/evenement_dto.dart';
import 'evenement_repository.dart';

@injectable
class EvenementsRepositoryImpl extends EvenementsRepository {
  final FirestoreService _firestoreService;
  final FirebaseFirestore _firestore;
  final StorageService _storageService;
  final FirebaseStorage _storage;

  EvenementsRepositoryImpl(
    this._firestoreService,
    this._firestore,
      this._storageService,
      this._storage
  );

  @override
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;

  @override
  Stream<Iterable<Evenement>> getEvenementStream() {
    return _firestoreService.collection('evenement').snapshots().map(
          (querySnapshot) => querySnapshot.docs
              .where((doc) =>
                  doc.data() != null) // Filtrer les documents non nulles
              .map((doc) => Evenement.fromMap(
                  doc.data() as Map<String, dynamic>, doc.id))
              .toList(),
        );
  }

  @override
  Future<Map<String, dynamic>?> getById(String evenementId) async {
    final docSnapshot =
        await firestore.collection('evenement').doc(evenementId).get();
    return docSnapshot.data() ?? {};
  }

  @override
  Future<void> add(EvenementDto evenementDto) async {
    try {
      await firestore.collection('evenement').add(evenementDto.toJson());
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de l\'événement: $e');
    }
  }

  @override
  Future<void> updateField(
      String evenementId, String fieldName, newValue) async {
    await firestore.collection('evenement').doc(evenementId).update({
      fieldName: newValue,
    });
  }

  @override

  Future<void> deleteEvenement(String evenementId) async {
    try {
      // Suppression du document dans Firestore
      await firestore.collection('evenement').doc(evenementId).delete();

      // Suppression du fichier dans Storage
      final storageRef = storage.ref().child('evenement/$evenementId');
      await storageRef.delete();

      debugPrint('Événement supprimé de Firestore et Storage : $evenementId');
    } catch (e) {
      debugPrint('Erreur lors de la suppression de l\'événement : $e');
      throw Exception('Impossible de supprimer l\'événement : $e');
    }
  }
}
