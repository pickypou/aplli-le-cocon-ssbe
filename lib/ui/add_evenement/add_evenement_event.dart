import 'dart:io';
import 'dart:typed_data';

abstract class AddEvenementEvent {}

class AddEvenementSignUpEvent extends AddEvenementEvent {
  final String id;
  final String title;
  final String fileType;
  final DateTime publishDate;
  final File file;
  final Uint8List? thumbnail;

  AddEvenementSignUpEvent({
    required this.id,
    required this.title,
    required this.fileType,
    required this.publishDate,
    required this.file,
    this.thumbnail,
  });
}
