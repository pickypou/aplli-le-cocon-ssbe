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
          (querySnapshot) => querySnapshot.docs.map((doc) {
            final data = doc.data();
            return Evenement.fromMap(data, doc.id);
          }).toList(),
        );
  }

  @override
  Future<void> add(EvenementDto evenementDto) async {
    await _firestore
        .collection('evenement')
        .doc(evenementDto.id)
        .set(evenementDto.toJson());
  }

  @override
  Future<void> deleteEvenement(String evenementId) async {
    await _firestore.collection('evenement').doc(evenementId).delete();
    await _storage.ref('evenement/$evenementId/').delete();
  }

  @override
  Future<Map<String, dynamic>?> getById(String evenementId) async {
    final doc = await _firestore.collection('evenement').doc(evenementId).get();
    return doc.data();
  }

  @override
  Future<void> updateField(
      String evenementId, String fieldName, dynamic newValue) async {
    await _firestore.collection('evenement').doc(evenementId).update({
      fieldName: newValue,
    });
  }
}
