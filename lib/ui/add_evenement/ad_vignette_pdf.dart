import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';

import '../../domain/usecases/generate_and_upload_thumbnail_use_case.dart';

class AddEvenementController {
  File? file;
  String? fileType;
  Uint8List? thumbnail; // Vignette générée

  final generateThumbnailUseCase = GetIt.instance<GenerateThumbnailUseCase>();

  Future<void> pickFile() async {
    debugPrint("Début de la sélection de fichier...");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile platformFile = result.files.first;
      file = File(platformFile.path!);
      fileType = platformFile.extension;
      debugPrint("Fichier sélectionné : ${file!.path}");
      debugPrint("Type de fichier : $fileType");

      // Génération de la vignette
      if (file != null) {
        debugPrint("Génération de la vignette...");
        thumbnail = await generateThumbnailUseCase.generateThumbnail(file!.path);
        if (thumbnail != null) {
          debugPrint("Vignette générée avec succès.");
        } else {
          debugPrint("Échec de la génération de la vignette.");
        }
      }
    } else {
      debugPrint("Aucun fichier sélectionné.");
      file = null;
      fileType = null;
      thumbnail = null;
    }
  }
}
