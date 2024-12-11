import 'package:intl/intl.dart';

class AvisClients {
  final String id;
  final String categories;
  final String text;
  final String firsname;
  final DateTime publishDate;

  AvisClients(
      {required this.id,
      required this.categories,
      required this.text,
      required this.firsname,
      required this.publishDate});
  //Formatte la date au format (DD/MM/YYYY)
  String get formattedPublishDate {
    return DateFormat('dd/MM/yyyy').format(publishDate);
  }

  factory AvisClients.fromMap(Map<String, dynamic>? data, String id) {
    return AvisClients(
      id: id,
      categories: data?['categories'] ?? '',
      text: data?['text'] ?? '',
      firsname: data?['firstname'] ?? '',
      publishDate: data?['publishDate'],
    );
  }
}
