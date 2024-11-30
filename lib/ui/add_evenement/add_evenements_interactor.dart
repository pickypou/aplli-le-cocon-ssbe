import 'dart:typed_data';

import 'package:app_lecocon_ssbe/core/di/api/firestore_service.dart';
import 'package:app_lecocon_ssbe/core/di/api/storage_service.dart';
import 'package:app_lecocon_ssbe/domain/entity/evenements.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pdfx/pdfx.dart';
import 'package:path/path.dart' as path;
import '../../core/di/di.dart';
import '../../data/repository/evenement_repository.dart';
import '../../domain/usecases/fetch_evenement_data_usecase.dart';

@injectable
class EvenementsInteractor {
  final evenementsRepository = getIt<EvenementsRepository>();
  final fetchEvenementDataUseCase = getIt<FetchEvenementDataUseCase>();
  final storageService = getIt<StorageService>();
  final firestore = getIt<FirestoreService>();



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
      String evenementId,
      ) async {
    try {
      final folderPath = 'evenement/$evenementId/';
      final fileExtension = path.extension(originalFileName).toLowerCase();

      // Standardize file name
      final standardFileName = 'file$fileExtension';
      final mainFileRef = storageService.ref('$folderPath$standardFileName');

      // Upload main file
      await mainFileRef.putData(fileBytes);
      final fileUrl = await mainFileRef.getDownloadURL();

      String thumbnailUrl = '';
      if (fileType == 'pdf') {
        final thumbnailBytes = await generatePdfThumbnail(fileBytes);
        final thumbnailRef = storageService.ref('${folderPath}thumbnail.png');
        await thumbnailRef.putData(thumbnailBytes!);
        thumbnailUrl = await thumbnailRef.getDownloadURL();
      } else {
        thumbnailUrl = fileUrl; // For images, use the main file as thumbnail
      }

      debugPrint('File uploaded successfully. Type: $fileType, URL: $fileUrl');
      return {
        'fileUrl': fileUrl,
        'thumbnailUrl': thumbnailUrl,
      };
    } catch (e) {
      debugPrint('Error uploading file: $e');
      throw Exception('Failed to upload file: $e');
    }
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
