import 'package:app_lecocon_ssbe/domain/entity/evenements.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../dto/evenement_dto.dart';

abstract class EvenementsRepository {
  FirebaseFirestore get firestore;

  Stream<Iterable<Evenements>> getEvenementStream();
  Future<Map<String, dynamic>?> getById(String evenementId);
  Future<void> add(EvenementDto evenementDto);  // Utilisation d'un DTO ici
  Future<void> updateField(String evenementId, String fieldName, dynamic newValue);
}
