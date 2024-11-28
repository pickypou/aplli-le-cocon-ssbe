import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';

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
    return _firestore.collection('evenement').snapshots().asyncMap(
          (querySnapshot) async {
        final evenements = await Future.wait(
          querySnapshot.docs.map((doc) async {
            final data = doc.data();
            final evenement = Evenement.fromMap(data, doc.id);

            try {
              final eventRef = _storage.ref().child('evenement/${evenement.id}');

              // Lister tous les fichiers dans le dossier de l'événement
              final ListResult result = await eventRef.listAll();

              String? fileUrl;
              String? thumbnailUrl;

              // Chercher le fichier principal
              for (Reference ref in result.items) {
                final String name = ref.name.toLowerCase();
                if (name.endsWith('.jpg') || name.endsWith('.jpeg') || name.endsWith('.png') || name.endsWith('.pdf')) {
                  fileUrl = await ref.getDownloadURL();
                  break;
                }
              }

              // Pour les PDFs, chercher la vignette
              if (evenement.fileType == 'pdf') {
                for (Reference ref in result.items) {
                  if (ref.name.toLowerCase().contains('thumbnail')) {
                    thumbnailUrl = await ref.getDownloadURL();
                    break;
                  }
                }
              } else {
                thumbnailUrl = fileUrl; // Pour les images, utiliser le fichier principal comme vignette
              }

              if (fileUrl != null) {
                return Evenement(
                  id: evenement.id,
                  title: evenement.title,
                  publishDate: evenement.publishDate,
                  fileType: evenement.fileType,
                  fileUrl: fileUrl,
                  thumbnailUrl: thumbnailUrl ?? fileUrl,
                );
              }

              debugPrint('Aucun fichier trouvé pour l\'événement ${evenement.id}');
              return evenement;
            } catch (e) {
              debugPrint('Erreur lors de la récupération des fichiers pour l\'événement ${evenement.id}: $e');
              return evenement;
            }
          }),
        );

        return evenements;
      },
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
    await _storage.ref('evenement/$evenementId').listAll().then((result) {
      for (var ref in result.items) {
        ref.delete();
      }
    });
  }

  @override
  Future<Map<String, dynamic>?> getById(String evenementId) async {
    final doc = await _firestore.collection('evenement').doc(evenementId).get();
    if (doc.exists) {
      final data = doc.data()!;
      final eventRef = _storage.ref().child('evenement/$evenementId');

      try {
        final ListResult result = await eventRef.listAll();

        String? fileUrl;
        String? thumbnailUrl;

        // Chercher le fichier principal
        for (Reference ref in result.items) {
          final String name = ref.name.toLowerCase();
          if (name.endsWith('.jpg') || name.endsWith('.jpeg') || name.endsWith('.png') || name.endsWith('.pdf')) {
            fileUrl = await ref.getDownloadURL();
            break;
          }
        }

        // Pour les PDFs, chercher la vignette
        if (data['fileType'] == 'pdf') {
          for (Reference ref in result.items) {
            if (ref.name.toLowerCase().contains('thumbnail')) {
              thumbnailUrl = await ref.getDownloadURL();
              break;
            }
          }
        } else {
          thumbnailUrl = fileUrl;
        }

        if (fileUrl != null) {
          data['fileUrl'] = fileUrl;
          data['thumbnailUrl'] = thumbnailUrl ?? fileUrl;
        }
      } catch (e) {
        debugPrint('Erreur lors de la récupération des fichiers pour l\'événement $evenementId: $e');
      }

      return data;
    }
    return null;
  }

  @override
  Future<void> updateField(
      String evenementId, String fieldName, dynamic newValue) async {
    await _firestore.collection('evenement').doc(evenementId).update({
      fieldName: newValue,
    });
  }
}

