import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:pdfx/pdfx.dart';
import 'package:flutter/material.dart';

@injectable
class GenerateThumbnailUseCase {
  Future<Uint8List?> generateThumbnail(Uint8List pdfBytes) async {
    try {
      final document = await PdfDocument.openData(pdfBytes);
      final page = await document.getPage(1);  // Open the first page

      // Render the page as a PNG image with doubled size for better quality
      final pageImage = await page.render(
        width: page.width * 2,
        height: page.height * 2,
        format: PdfPageImageFormat.png,
      );

      await page.close();
      await document.close();

      if (pageImage == null || pageImage.bytes == null) {
        debugPrint('Failed to generate thumbnail: pageImage or bytes is null');
        return null;
      }

      debugPrint('Thumbnail generated successfully. Size: ${pageImage.bytes!.length} bytes');
      return pageImage.bytes;
    } catch (e) {
      debugPrint('Error generating thumbnail for PDF: $e');
      return null;
    }
  }
}

