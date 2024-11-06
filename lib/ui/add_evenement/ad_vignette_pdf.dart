import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/usecases/generate_and_upload_thumbnail_use_case.dart';

class AddEvenementController {
  File? file;
  String? fileType;
  Uint8List? thumbnail; // Vignette générée
  String? fileUrl;
  String? thumbnailUrl;

  final generateThumbnailUseCase = GetIt.instance<GenerateThumbnailUseCase>();

  // Fonction pour choisir un fichier et générer la vignette
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

  // Fonction pour uploader le fichier et la vignette
  Future<void> uploadFiles() async {
    if (file == null) {
      debugPrint("Aucun fichier sélectionné pour l'upload.");
      return;
    }

    try {
      debugPrint("Début de l'upload du fichier principal...");
      // Upload du fichier principal
      String filePath = "uploads/${DateTime.now().millisecondsSinceEpoch}.${fileType}";
      fileUrl = await _uploadFile(file!, filePath);
      debugPrint("Fichier principal uploadé avec succès : $fileUrl");

      // Upload de la vignette si elle a été générée
      if (thumbnail != null) {
        debugPrint("Début de l'upload de la vignette...");
        String thumbnailPath = "thumbnails/${DateTime.now().millisecondsSinceEpoch}.jpg";
        thumbnailUrl = await _uploadThumbnail(thumbnail!, thumbnailPath);
        debugPrint("Vignette uploadée avec succès : $thumbnailUrl");
      } else {
        debugPrint("Aucune vignette générée, donc pas d'upload de vignette.");
      }
    } catch (e) {
      debugPrint("Erreur lors de l'upload : $e");
    }
  }

  // Fonction générique pour uploader un fichier
  Future<String> _uploadFile(File file, String path) async {
    try {
      debugPrint("Upload du fichier vers Firebase Storage : $path");
      final storageRef = FirebaseStorage.instance.ref().child(path);
      final uploadTask = storageRef.putFile(file);

      // Surveiller l'état de l'upload
      await uploadTask.whenComplete(() => null);

      // Récupérer l'URL du fichier après l'upload
      String downloadUrl = await storageRef.getDownloadURL();
      debugPrint("URL du fichier uploadé : $downloadUrl");
      return downloadUrl;
    } catch (e) {
      debugPrint("Erreur lors de l'upload du fichier : $e");
      rethrow; // Lancer l'exception pour la capturer dans le bloc try-catch principal
    }
  }

  // Fonction pour uploader la vignette générée
  Future<String> _uploadThumbnail(Uint8List thumbnailData, String path) async {
    try {
      debugPrint("Upload de la vignette vers Firebase Storage : $path");
      final storageRef = FirebaseStorage.instance.ref().child(path);
      final uploadTask = storageRef.putData(thumbnailData);

      // Surveiller l'état de l'upload
      await uploadTask.whenComplete(() => null);

      // Récupérer l'URL de la vignette après l'upload
      String downloadUrl = await storageRef.getDownloadURL();
      debugPrint("URL de la vignette uploadée : $downloadUrl");
      return downloadUrl;
    } catch (e) {
      debugPrint("Erreur lors de l'upload de la vignette : $e");
      rethrow; // Lancer l'exception pour la capturer dans le bloc try-catch principal
    }
  }
}
