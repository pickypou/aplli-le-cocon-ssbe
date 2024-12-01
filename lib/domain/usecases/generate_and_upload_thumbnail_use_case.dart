import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter/material.dart';

@injectable
class GenerateThumbnailUseCase {
  Future<Uint8List?> generateThumbnail(Uint8List pdfBytes) async {
    try {
      final document = await PdfDocument.openData(pdfBytes);
      final page = await document.getPage(1);  // Première page

      final pageImage = await page.render(
        width: page.width * 2,  // Taille doublée pour une meilleure qualité
        height: page.height * 2,
        format: PdfPageImageFormat.png,
      );

      await page.close();
      await document.close();

      if (pageImage == null || pageImage.bytes == null) {
        debugPrint('Erreur : miniature ou octets absents.');
        return null;
      }

      debugPrint('Miniature générée avec succès. Taille : ${pageImage.bytes!.length} octets');
      return pageImage.bytes;
    } catch (e) {
      debugPrint('Erreur lors de la génération de la miniature : $e');
      return null;
    }
  }
}


