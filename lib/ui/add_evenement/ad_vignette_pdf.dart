import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import '../../domain/usecases/generate_and_upload_thumbnail_use_case.dart';

class AddEvenementController {
  File? file;
  String? fileType;
  Uint8List? thumbnail; // Vignette générée
  final generateThumbnailUseCase = GetIt.instance<GenerateThumbnailUseCase>();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

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

          // Maintenant, uploader le fichier et la vignette
          await uploadFileAndThumbnail();
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

  Future<void> uploadFileAndThumbnail() async {
    if (file == null || thumbnail == null) return;

    try {
      // Nom du fichier PDF
      String fileName = file!.uri.pathSegments.last;
      // Utiliser un identifiant unique pour chaque événement
      String evenementId = "unique_event_id"; // Remplacez ceci par un identifiant unique ou généré

      // Chemin pour télécharger le fichier PDF
      Reference fileRef = _firebaseStorage.ref().child('evenement/$evenementId/file.pdf');
      UploadTask uploadFileTask = fileRef.putFile(file!);

      // Chemin pour télécharger la vignette associée
      String thumbnailName = 'evenement/$evenementId/thumbnail.jpg';
      Reference thumbnailRef = _firebaseStorage.ref().child(thumbnailName);
      UploadTask uploadThumbnailTask = thumbnailRef.putData(thumbnail!);

      // Attendre que les deux fichiers soient téléchargés
      await Future.wait([
        uploadFileTask.whenComplete(() {}),
        uploadThumbnailTask.whenComplete(() {}),
      ]);

      // Récupérer les URL de téléchargement des fichiers
      String fileUrl = await fileRef.getDownloadURL();
      String thumbnailUrl = await thumbnailRef.getDownloadURL();

      debugPrint("URL du fichier PDF uploadé : $fileUrl");
      debugPrint("URL de la vignette uploadée : $thumbnailUrl");

      // Vous pouvez maintenant stocker ces URLs dans votre base de données ou mettre à jour l'événement
    } catch (e) {
      debugPrint("Erreur lors de l'upload : $e");
    }
  }

}

