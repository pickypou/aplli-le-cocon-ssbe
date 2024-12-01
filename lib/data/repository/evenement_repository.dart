import 'package:app_lecocon_ssbe/domain/entity/evenements.dart';

import '../dto/evenement_dto.dart';

abstract class EvenementsRepository {
  Stream<Iterable<Evenement>> getEvenementStream();
  Future<Map<String, dynamic>?> getById(String evenementId);
  Future<void> add(EvenementDto evenementDto); // Utilisation d'un DTO ici
  Future<void> deleteEvenement(String evenementId);  Future<void> updateField(
      String evenementId, String fieldName, dynamic newValue);
}
