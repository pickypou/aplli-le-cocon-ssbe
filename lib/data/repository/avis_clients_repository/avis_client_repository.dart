import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/avis_clients/avis_clients.dart';

abstract class AvisClientsRepository {
  FirebaseFirestore get fireStore;
  Stream<Iterable<AvisClients>> getAvisClientsStream();
  Future<Map<String, dynamic>> getById(String avisClientsId);
  Future<void> add(Map<String, dynamic>data);
  Future<void>updateField(
      String avisClientsId, String fieldName, String newValue);
}

class ConcretedAvisClientsRepository extends AvisClientsRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Stream<Iterable<AvisClients>> getAvisClientsStream() {
    return firestore.collection('avis_clients').snapshots().map(
          (querySnapshot) => querySnapshot.docs
          .map((doc)=>AvisClients.fromMap(doc.data(), doc.id))
          .toList(),
    );
  }

  @override
  FirebaseFirestore get fireStore => throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> getById(String avisClientsId) async {
    final docSnapshot =
    await firestore.collection('avis_client').doc(avisClientsId).get();
    return docSnapshot.data() ?? {};
  }

  @override
  Future<void> add(Map<String, dynamic> data) async {
    await firestore.collection('avis_clients').add(data);
  }

  @override
  Future<void> updateField(
      String avisClientsId,
      String fieldName,
      String newValue) async {
    await firestore
        .collection('avis_client')
        .doc(avisClientsId)
        .update({fieldName: newValue});

  }

  Stream<Iterable<AvisClients>> getAvisClientStream() {
    // TODO: implement getAvisClientStream
    throw UnimplementedError();
  }

}