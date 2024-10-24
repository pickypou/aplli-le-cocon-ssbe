
import 'package:intl/intl.dart';

class Evenements {
  final String id;
  final String fileUrl;
  final String fileType;
  final DateTime publishDate;


  Evenements({
    required this.id,
    required this.fileType,
    required this.fileUrl,
    required this.publishDate
});

  //Formatte la date au format (DD/MM/YYYY)
  String get formattedPublishDate {
    return DateFormat('dd/MM/yyyy').format(publishDate);
  }

  factory Evenements.fromMap(Map<String, dynamic>? data, String id) {
    return Evenements(
        id: id,
      fileType: data? ['fileType'] ?? '',
      fileUrl: data? ['fileUrl'] ?? '',
      publishDate: data? ['publishDATE']

    );
  }
}