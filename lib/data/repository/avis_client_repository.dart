import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/avis_clients.dart';


abstract class AvisClientsRepository {
  FirebaseFirestore get fireStore;
  Stream<Iterable<AvisClients>> getAvisClientsStream();
  Future<Map<String, dynamic>> getById(String avisClientsId);
  Future<void> add(Map<String, dynamic>data);
  Future<void>updateField(
      String avisClientsId, String fieldName, String newValue);
}

