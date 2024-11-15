import 'package:intl/intl.dart';

class Evenement {
  final String id;
  final String title;
  final String fileUrl;
  final String fileType;
  final String? thumbnailUrl;  // Ici, Uint8List pour une vignette en mémoire
  final DateTime publishDate;

  Evenement({
    required this.id,
    required this.title,
    required this.fileUrl,
    required this.fileType,
    this.thumbnailUrl,
    required this.publishDate,
  });

  // Formatte la date au format (DD/MM/YYYY)
  String get formattedPublishDate {
    return DateFormat('dd/MM/yyyy').format(publishDate);
  }

  factory Evenement.fromMap(Map<String, dynamic> data, String id) {
    return Evenement(
      id: id,
      title: data['title'] ?? '',
      fileType: data['fileType'] ?? '',
      fileUrl: data['fileUrl'] ?? '',
      thumbnailUrl: data['thumbnailUrl'], // Uint8List nécessite une gestion spéciale si stocké sous forme de string
      publishDate: DateTime.parse(data['publishDate'] ?? DateTime.now().toIso8601String()), // Gestion de date
    );
  }
}