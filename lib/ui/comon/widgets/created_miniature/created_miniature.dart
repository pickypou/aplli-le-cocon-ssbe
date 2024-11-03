import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_thumbnail/pdf_thumbnail.dart';

class PdfMiniature extends StatefulWidget {
  final String pdfUrl;

  const PdfMiniature({super.key, required this.pdfUrl});

  @override
  PdfMiniatureState createState() => PdfMiniatureState();
}

class PdfMiniatureState extends State<PdfMiniature> {
  late Future<File> pdfFile;
  var currentPage = 0;

  @override
  void initState() {
    super.initState();
    pdfFile = DownloadService.downloadFile(widget.pdfUrl, 'sample.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Miniature'),
      ),
      body: FutureBuilder<File>(
        future: pdfFile,
        builder: (context, snapshot) {
          return Center(
            child: snapshot.hasData
                ? PdfThumbnail.fromFile(
              snapshot.data!.path,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
              height: 200, // Hauteur de la miniature
              currentPageWidget: (page, isCurrentPage) {
                return Positioned(
                  bottom: 50,
                  right: 0,
                  child: Container(
                    height: 30,
                    width: 30,
                    color: isCurrentPage ? Colors.green : Colors.pink,
                    alignment: Alignment.center,
                    child: Text(
                      '${page + 1}', // Afficher le numéro de la page
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
              currentPageDecoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.orange,
                    width: 10,
                  ),
                ),
              ),
              onPageClicked: (page) {
                setState(() {
                  currentPage = page + 1; // Mettre à jour la page actuelle
                });
                if (kDebugMode) {
                  print('Page $page clicked');
                }
              }, currentPage: 0,
            )
                : const CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class DownloadService {
  static final _httpClient = HttpClient();

  static Future<File> downloadFile(String url, String filename) async {
    var request = await _httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
}
