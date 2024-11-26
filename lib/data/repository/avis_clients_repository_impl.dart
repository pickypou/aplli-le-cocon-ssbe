

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/avis_clients.dart';
import 'avis_client_repository.dart';


class AvisClientsRepositoryImpl extends AvisClientsRepository {
  final FirebaseFirestore _firestore;

  AvisClientsRepositoryImpl({FirebaseFirestore? firestore})
  : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  FirebaseFirestore get fireStore => _firestore;

  @override
  Stream<Iterable<AvisClients>> getAvisClientsStream() {
    return _firestore.collection('avis_clients').snapshots().map(
          (querySnapshot) => querySnapshot.docs
          .map((doc)=>AvisClients.fromMap(doc.data(), doc.id))
          .toList(),
    );
  }


  @override
  Future<Map<String, dynamic>> getById(String avisClientsId) async {
    final docSnapshot =
    await _firestore.collection('avis_client').doc(avisClientsId).get();
    return docSnapshot.data() ?? {};
  }

  @override
  Future<void> add(Map<String, dynamic> data) async {
    await _firestore.collection('avis_clients').add(data);
  }

  @override
  Future<void> updateField(
      String avisClientsId,
      String fieldName,
      String newValue) async {
    await _firestore
        .collection('avis_client')
        .doc(avisClientsId)
        .update({fieldName: newValue});

  }



}