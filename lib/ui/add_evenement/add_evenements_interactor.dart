import 'dart:typed_data';

import 'package:app_lecocon_ssbe/core/di/api/firestore_service.dart';
import 'package:app_lecocon_ssbe/core/di/api/storage_service.dart';
import 'package:app_lecocon_ssbe/domain/entity/evenements.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pdfx/pdfx.dart';

import '../../data/repository/evenement_repository.dart';
import '../../domain/usecases/fetch_evenement_data_usecase.dart';

@injectable
class EvenementsInteractor {
  final EvenementsRepository evenementsRepository;
  final FetchEvenementDataUseCase fetchEvenementDataUseCase;
  final StorageService storageService;
  final FirestoreService firestore;

  EvenementsInteractor(
    this.evenementsRepository,
    this.fetchEvenementDataUseCase,
    this.storageService,
    this.firestore,
  );
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
    String originalFileName,
    String fileType,
    String folderId,
    FirebaseStorage storage, // Injection via paramètre
  ) async {
    // Création du chemin pour le dossier
    final folderPath = '$folderId/';
    final fileExtension = originalFileName.split('.').last;

    // Nom du fichier principal
    final mainFileName = originalFileName; // Utiliser le nom original
    final mainFileRef = storage.ref('$folderPath$mainFileName');

    // Upload du fichier principal
    await mainFileRef.putData(fileBytes);
    final fileUrl = await mainFileRef.getDownloadURL();

    // Si le fichier est un PDF, générer une miniature
    String? thumbnailUrl;
    if (fileType == 'pdf') {
      final thumbnailBytes = await generatePdfThumbnail(fileBytes);
      final thumbnailName =
          'thumbnail_$originalFileName.png'; // Ajouter un préfixe pour éviter les conflits
      final thumbnailRef = storage.ref('$folderPath$thumbnailName');
      await thumbnailRef.putData(thumbnailBytes!);
      thumbnailUrl = await thumbnailRef.getDownloadURL();
      debugPrint(fileType);
    }

    return {
      'fileUrl': fileUrl,
      'thumbnailUrl': thumbnailUrl ?? '', // Vide si pas de miniature
    };
  }

  Future<void> addEvenement(Evenement evenement) async {
    try {
      await firestore.collection('evenement').doc(evenement.id).set({
        'title': evenement.title,
        'fileUrl': evenement.fileUrl,
        'thumbnailUrl': evenement.thumbnailUrl,
        'fileType': evenement.fileType,
        'publishDate': evenement.publishDate,
      });
    } catch (e) {
      debugPrint('Erreur lors de l\'ajout de l\'événement : $e'.toString());
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
