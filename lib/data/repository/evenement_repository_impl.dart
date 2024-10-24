

import 'package:app_lecocon_ssbe/core/di/api/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/evenements.dart';
import 'evenement_repository.dart';

@injectable
class EvenementsRepositoryImpl extends EvenementsRepository {
  final FirestoreService _firestoreService;
  final FirebaseFirestore _firestore;

  @factoryMethod
  EvenementsRepositoryImpl(
      this._firestoreService,
      @factoryParam FirebaseFirestore? firestore
      ) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  FirebaseFirestore get firestore => _firestore;

  @override
  Stream<Iterable<Evenements>> getEvenementStream() {
    return _firestoreService.collection('evenement').snapshots().map(
          (querySnapshot) => querySnapshot.docs
          .map((doc) => Evenements.fromMap(doc.data() as Map<String, dynamic>?, doc.id))
          .toList(),
    );
  }


  FirebaseFirestore get fireStore => throw UnimplementedError();

  @override
  Future<Map<String, dynamic>?> getById(String evenementId) async {
    final docSnapshot =
    await firestore.collection('evenement').doc(evenementId).get();
    return docSnapshot.data() ?? {};
  }

  @override
  Future<void> add(Map<String, dynamic> data) async {
    try {
      await firestore.collection('evenement').add(data);
    }catch(e) {
      throw Exception('Erreur lors de l\'ajout de l\'evenement;$e');
    }
  }


  @override
  Future<void> updateField(
      String evenementId, String fieldName, newValue) async {

    await firestore.collection('evenement').doc(evenementId).update({
      fieldName: newValue,
    });
  }

}