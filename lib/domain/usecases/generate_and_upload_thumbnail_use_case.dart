import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:pdfx/pdfx.dart';

@injectable
class GenerateThumbnailUseCase {
  Future<Uint8List?> generateThumbnail(String pdfPath) async {
    if (!await hasPdfSupport()) {
      throw Exception('PDF rendering not supported on this platform');
    }

    final document = await PdfDocument.openFile(pdfPath);
    final page = await document.getPage(1);

    final pageImage = await page.render(
      width: page.width * 2,
      height: page.height * 2,
      format: PdfPageImageFormat.png,
    );

    await page.close();
    await document.close();

    return pageImage?.bytes;
  }
}
