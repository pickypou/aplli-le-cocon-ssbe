
import 'dart:typed_data';

import 'package:intl/intl.dart';

class Evenements {
  final String id;
  final String title;
  final String fileUrl;
  final String fileType;
  final Uint8List? thumbnailUrl;
  final DateTime publishDate;


  Evenements({
    required this.id,
    required this.fileType,
    required this.fileUrl,
    required this.publishDate,
    required this.title,
    this.thumbnailUrl
});

  //Formatte la date au format (DD/MM/YYYY)
  String get formattedPublishDate {
    return DateFormat('dd/MM/yyyy').format(publishDate);
  }

  factory Evenements.fromMap(Map<String, dynamic>? data, String id) {
    return Evenements(
        id: id,
      title: data? ['title'] ?? '',
      fileType: data? ['fileType'] ?? '',
      fileUrl: data? ['fileUrl'] ?? '',
      thumbnailUrl: data?['thumbnailUrl'] ?? '',
      publishDate: data? ['publishDATE']

    );
  }
}