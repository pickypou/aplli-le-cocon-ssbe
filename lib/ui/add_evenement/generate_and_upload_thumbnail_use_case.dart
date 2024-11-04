import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:pdf_render/pdf_render.dart';

@injectable
class GenerateAndUploadThumbnailUseCase {
  final FirebaseStorageService storageService;

  GenerateAndUploadThumbnailUseCase(this.storageService);

  Future<String?> call(File pdfFile) async {
    try {
      // Génération de la vignette
      final pdfDocument = await PdfDocument.openFile(pdfFile.path);
      final page = await pdfDocument.getPage(1);
      final pageImage = await page.render(
        width: page.width,
        height: page.height,
      );

      final thumbnailBytes = pageImage.bytes;
      final thumbnailFile = File('${pdfFile.path}_thumbnail.jpg');
      await thumbnailFile.writeAsBytes(thumbnailBytes);
      await page.close();
      await pdfDocument.close();

      // Upload de la vignette dans Firebase
      final thumbnailUrl = await storageService.uploadFile(thumbnailFile, 'thumbnails');
      return thumbnailUrl;
    } catch (e) {
      // Gérer les erreurs
      print("Erreur lors de la génération de la vignette : $e");
      return null;
    }
  }
}
