import 'dart:typed_data';

import 'package:app_lecocon_ssbe/core/di/api/firestore_service.dart';
import 'package:app_lecocon_ssbe/core/di/api/storage_service.dart';
import 'package:app_lecocon_ssbe/domain/entity/evenements.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import '../../core/di/di.dart';
import '../../data/repository/evenement_repository.dart';
import '../../domain/usecases/fetch_evenement_data_usecase.dart';

class EvenementsInteractor {
  final evenementsRepository = getIt<EvenementsRepository>();
  final fetchEvenementDataUseCase = getIt<FetchEvenementDataUseCase>();
  final _storageService = getIt<StorageService>();
  final _firestore = getIt<FirestoreService>();

  Future<Iterable<Evenement>> fetchEvenementData() async {
    try {
      final evenement = await fetchEvenementDataUseCase.getEvenement();
      return evenement;
    } catch (e) {
      debugPrint('Erreur lors de la récupération de l\'événement : $e');
      rethrow;
    }
  }

  Future<Map<String, String>> uploadFileWithThumbnail(
    Uint8List fileBytes,
    String fileName,
    String fileType,
    String evenementId,
  ) async {
    try {
      // Créer un identifiant unique pour l'événement
      String eventId = DateTime.now().millisecondsSinceEpoch.toString();
      String folderPath = 'evenement/$eventId/';

      // Upload du fichier principal (PDF ou image)
      final Reference fileRef =
          FirebaseStorage.instance.ref().child('$folderPath$fileName');
      await fileRef.putData(fileBytes);

      String fileUrl = await fileRef.getDownloadURL();

      String thumbnailUrl = '';
      // Si c'est un PDF, générer une vignette
      if (fileType == 'pdf') {
        Uint8List? thumbnailBytes = await generatePdfThumbnail(fileBytes);
        final Reference thumbnailRef =
            FirebaseStorage.instance.ref().child('$folderPath/thumbnail.png');
        await thumbnailRef.putData(thumbnailBytes!);
        thumbnailUrl = await thumbnailRef.getDownloadURL();
      }

      return {'fileUrl': fileUrl, 'thumbnailUrl': thumbnailUrl};
    } catch (e) {
      throw Exception('Erreur lors de l\'upload : $e');
    }
  }

  Future<void> addEvenement(Evenement evenement) async {
    try {
      await _firestore.collection('evenement').doc(evenement.id).set({
        'title': evenement.title,
        'fileUrl': evenement.fileUrl,
        'thumbnailUrl': evenement.thumbnailUrl,
        'fileType': evenement.fileType,
        'publishDate': evenement.publishDate,
      });
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de l\'événement : $e');
    }
  }

  Future<Uint8List?> generatePdfThumbnail(Uint8List pdfBytes) async {
    final doc = await PdfDocument.openData(pdfBytes);
    final page = await doc.getPage(1); // Première page du PDF
    final pageImage = await page.render(
      width: page.width,
      height: page.height,
      format: PdfPageImageFormat.png,
    );
    await page.close();
    await doc.close();
    return pageImage?.bytes; // Retourner les octets de l'image
  }
}
