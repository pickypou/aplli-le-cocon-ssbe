import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/evenements.dart';
import '../dto/evenement_dto.dart';
import 'evenement_repository.dart';

@Injectable(as: EvenementsRepository)
class EvenementsRepositoryImpl extends EvenementsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  EvenementsRepositoryImpl(this._firestore, this._storage);

  @override
  Stream<Iterable<Evenement>> getEvenementStream() {
    return _firestore.collection('evenement').snapshots().map(
          (querySnapshot) => querySnapshot.docs
              .where((doc) => doc.data() != null)
              .map((doc) => Evenement.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  @override
  Future<Map<String, dynamic>?> getById(String evenementId) async {
    final docSnapshot =
        await _firestore.collection('evenement').doc(evenementId).get();
    return docSnapshot.data();
  }

  @override
  Future<void> add(EvenementDto evenementDto) async {
    try {
      await _firestore.collection('evenement').add(evenementDto.toJson());
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de l\'événement: $e');
    }
  }

  @override
  Future<void> updateField(
      String evenementId, String fieldName, dynamic newValue) async {
    await _firestore.collection('evenement').doc(evenementId).update({
      fieldName: newValue,
    });
  }

  @override
  Future<void> deleteEvenement(String evenementId) async {
    try {
      await _firestore.collection('evenement').doc(evenementId).delete();
      await _storage.ref().child('evenement/$evenementId').delete();
    } catch (e) {
      throw Exception('Impossible de supprimer l\'événement : $e');
    }
  }

  @override
  // TODO: implement firestore
  FirebaseFirestore get firestore => throw UnimplementedError();
}
