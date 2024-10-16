import 'package:app_lecocon_ssbe/data/domain/entity/evenement/evenements.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class EvenementsRepository {
  FirebaseFirestore get firestore;

  Stream<Iterable<Evenements>> getEvenementStream();
  Future<Map<String, dynamic>?> getById(String evenementId);
  Future<void> add(Map<String, dynamic> data);
  Future<void> updateField(String evenementId, String fieldName, newValue);
}

class ConcretedEvenementsRepository extends EvenementsRepository {
  @override
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Stream<Iterable<Evenements>> getEvenementStream() {
    return firestore.collection('evenement').snapshots().map(
          (querySnapshot) => querySnapshot.docs
          .map((doc) => Evenements.fromMp(doc.data(), doc.id))
          .toList(),
    );
  }

  @override
  Future<Map<String, dynamic>?> getById(String evenementId) {
    return firestore
        .collection('evenement')
        .doc(evenementId)
        .get()
        .then((docSnapshot) => docSnapshot.data());
  }

  @override
  Future<void> add(Map<String, dynamic> data) async {
    try {
      await firestore.collection('evenement').add(data);
    } catch (error) {
      debugPrint('Error adding evenement : $error');
      rethrow;
    }
  }

  @override
  Future<void> updateField(
      String evenementId, String fieldName, newValue) async {
    try {
      await firestore.collection('evenement').doc(evenementId).update({
        fieldName: newValue,
      });
    } catch (error) {
      debugPrint('Error updating field : $error');
      rethrow;
    }
  }

  FirebaseFirestore get firebaseInstance => firestore;
}
