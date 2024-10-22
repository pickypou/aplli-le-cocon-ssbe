import 'package:app_lecocon_ssbe/domain/entity/evenements.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class EvenementsRepository {
  FirebaseFirestore get firestore;

  Stream<Iterable<Evenements>> getEvenementStream();
  Future<Map<String, dynamic>?> getById(String evenementId);
  Future<void> add(Map<String, dynamic> data);
  Future<void> updateField(String evenementId, String fieldName, newValue);
}


