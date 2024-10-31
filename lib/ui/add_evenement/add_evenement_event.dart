import 'dart:io';

abstract class AddEvenementEvent {}

class AddEvenementSignUpEvent extends AddEvenementEvent {
  final String id;
  final String title;
  final String fileUrl;
  final String fileType;
  final String fileName;
  final DateTime publishDate;
  final File file;

  AddEvenementSignUpEvent(
      {required this.id,
      required this.title,
      required this.fileUrl,
      required this.fileType,
        required this.fileName,
      required this.publishDate,
      required this.file});
}

class AddEvenementButtonPressed extends AddEvenementEvent {
  final File file;
  final String fileType;
  final String fileName;

  AddEvenementButtonPressed({required this.file, required this.fileType, required this.fileName});
}
