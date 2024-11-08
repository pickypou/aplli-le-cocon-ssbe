import 'package:app_lecocon_ssbe/core/di/api/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/evenements.dart';
import '../dto/evenement_dto.dart';
import 'evenement_repository.dart';

@injectable
class EvenementsRepositoryImpl extends EvenementsRepository {
  final FirestoreService _firestoreService;
  final FirebaseFirestore _firestore;

  EvenementsRepositoryImpl(
      this._firestoreService,
      this._firestore,
      );

  @override
  FirebaseFirestore get firestore => _firestore;

  @override
  Stream<Iterable<Evenements>> getEvenementStream() {
    return _firestoreService.collection('evenement').snapshots().map(
          (querySnapshot) => querySnapshot.docs
          .where((doc) => doc.data() != null)  // Filtrer les documents non nulles
          .map((doc) => Evenements.fromMap(doc.data() as Map<String, dynamic>, doc.id))
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
  Future<void> updateField(String evenementId, String fieldName, newValue) async {
    await firestore.collection('evenement').doc(evenementId).update({
      fieldName: newValue,
    });
  }
}
