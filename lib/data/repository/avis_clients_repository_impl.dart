import 'package:app_lecocon_ssbe/core/di/api/firestore_service.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/avis_clients.dart';
import 'avis_client_repository.dart';

@Injectable(as: AvisClientsRepository)
class AvisClientsRepositoryImpl extends AvisClientsRepository {
  final FirestoreService _firestore;

  AvisClientsRepositoryImpl(this._firestore);

  @override
  Stream<Iterable<AvisClients>> getAvisClientsStream() {
    return _firestore.collection('avis_clients').snapshots().map(
          (querySnapshot) => querySnapshot.docs
              .map((doc) => AvisClients.fromMap(doc.data(), doc.id))
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
  Future<void> deleteAvisClients(String avisClientsId) async {
    try {
      // Supprime uniquement le document spécifique dans Firestore
      await _firestore.collection('avis_clients').doc(avisClientsId).delete();
      print('Avis supprimé avec succès : $avisClientsId');
    } catch (e) {
      print('Erreur lors de la suppression de l\'avis : $e');
      rethrow; // Vous pouvez choisir de gérer l'erreur différemment si nécessaire
    }
  }

  @override
  Future<void> updateField(
      String avisClientsId, String fieldName, String newValue) async {
    await _firestore
        .collection('avis_client')
        .doc(avisClientsId)
        .update({fieldName: newValue});
  }
}
