import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter/material.dart';

@injectable
class GenerateThumbnailUseCase {
  Future<Uint8List?> generateThumbnail(String pdfPath) async {
    if (!await _hasPdfSupport()) {
      throw Exception('PDF rendering not supported on this platform');
    }

    try {
      final document = await PdfDocument.openFile(pdfPath);
      final page = await document.getPage(1);  // Ouvrir la première page

      // Rendre la page comme une image PNG avec une taille doublée pour plus de qualité
      final pageImage = await page.render(
        width: page.width * 2,
        height: page.height * 2,
        format: PdfPageImageFormat.png,
      );

      await page.close();
      await document.close();

      return pageImage?.bytes;  // Retourner l'image sous forme d'Uint8List
    } catch (e) {
      debugPrint('Error generating thumbnail for PDF: $e');
      rethrow;
    }
  }

  // Méthode privée pour vérifier le support PDF
  Future<bool> _hasPdfSupport() async {
    // Votre logique ici pour vérifier le support des PDF
    // Par exemple, vous pouvez vérifier les plateformes ou les versions
    return true;  // Exemple simplifié
  }
}
