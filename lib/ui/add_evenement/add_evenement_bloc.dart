import 'dart:io';
import 'dart:typed_data';

import 'package:app_lecocon_ssbe/domain/entity/evenements.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as path;

import '../../domain/usecases/generate_and_upload_thumbnail_use_case.dart';
import 'add_evenement_event.dart';
import 'add_evenement_state.dart';

class AddEvenementsBloc extends Bloc<AddEvenementEvent, AddEvenementsState> {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final generateThumbnailUseCase = GetIt.instance<GenerateThumbnailUseCase>();

  AddEvenementsBloc() : super(AddEvenementsSignUpInitialState()) {
    on<AddEvenementEvent>((event, emit) async {
      if (event is AddEvenementSignUpEvent) {
        await _handleAddEvenementSignUpEvent(event, emit);
      }
    });
  }

  Future<void> _handleAddEvenementSignUpEvent(
      AddEvenementSignUpEvent event, Emitter<AddEvenementsState> emit) async {
    emit(AddEvenementsSignUpLoadingState());

    try {
      Uint8List? thumbnail;

      // Génération de la vignette uniquement si le fichier est un PDF
      if (event.fileType == 'pdf') {
        thumbnail =
            await generateThumbnailUseCase.generateThumbnail(event.file.path);
      }

      String evenementId =
          FirebaseFirestore.instance.collection('evenements').doc().id;

      // Upload du fichier principal
      String fileUrl =
          await _uploadFile(event.file, evenementId, event.fileType);

      // Upload de la vignette si elle a été générée
      String? thumbnailUrl;
      if (thumbnail != null) {
        thumbnailUrl = await _uploadThumbnail(thumbnail, evenementId);
      }

      // Création de l'entité événement
      final evenement = Evenements(
        id: evenementId,
        title: event.title,
        fileType: event.fileType,
        fileUrl: fileUrl,
        publishDate: event.publishDate,
        thumbnailUrl: thumbnailUrl, // Null pour les images
      );

      // Ajout des données dans Firestore
      await FirebaseFirestore.instance
          .collection('evenements')
          .doc(evenementId)
          .set({
        'fileType': evenement.fileType,
        'fileUrl': evenement.fileUrl,
        'thumbnailUrl': evenement.thumbnailUrl,
        'title': evenement.title,
        'publishDate': evenement.publishDate,
      });

      emit(AddEvenementsSignUpSuccessState(evenementId: evenementId));
    } catch (error) {
      debugPrint("Erreur lors de l'ajout de l'événement : $error");
      emit(AddEvenementsSignUpErrorState(error: error.toString()));
    }
  }

  Future<String> _uploadFile(
      File file, String evenementId, String fileType) async {
    // Récupérer l'extension du fichier source, qu'elle soit .jpg, .jpeg, .png ou .pdf
    String extension = path
        .extension(file.path)
        .replaceFirst('.', ''); // 'jpg', 'jpeg', 'png', 'pdf'
    debugPrint("Extension détectée : $extension");

    // Définir le nom du fichier en utilisant l'extension d'origine
    Reference fileRef =
        _firebaseStorage.ref().child('evenement/$evenementId/file.$extension');

    // Upload du fichier
    await fileRef.putFile(file);

    // Obtenir l'URL du fichier uploadé
    return await fileRef.getDownloadURL();
  }

  Future<String> _uploadThumbnail(
      Uint8List thumbnail, String evenementId) async {
    Reference thumbnailRef =
        _firebaseStorage.ref().child('evenement/$evenementId/thumbnail.jpg');
    await thumbnailRef.putData(thumbnail);
    return await thumbnailRef.getDownloadURL();
  }
}
