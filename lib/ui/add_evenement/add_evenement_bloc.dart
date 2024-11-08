import 'package:app_lecocon_ssbe/domain/entity/evenements.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_evenement_event.dart';
import 'add_evenement_state.dart';
import '../../domain/usecases/generate_and_upload_thumbnail_use_case.dart';

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

  Future<void> _handleAddEvenementSignUpEvent(AddEvenementSignUpEvent event, Emitter<AddEvenementsState> emit) async {
    emit(AddEvenementsSignUpLoadingState());
    try {
      File? file;
      String? fileType;
      String? title;

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile platformFile = result.files.first;
        file = File(platformFile.path!);
        fileType = platformFile.extension;
        title = platformFile.name;

        Uint8List? thumbnail = await generateThumbnailUseCase.generateThumbnail(file.path);

        if (thumbnail != null) {
          String evenementId = FirebaseFirestore.instance.collection('evenements').doc().id;
          String fileUrl = await _uploadFile(file, evenementId);
          String thumbnailUrl = await _uploadThumbnail(thumbnail, evenementId);

          final evenement = Evenements(
            id: evenementId,
            title: title,
            fileType: fileType ?? "Type inconnu",
            fileUrl: fileUrl,
            publishDate: Timestamp.now().toDate(),
            thumbnailUrl: thumbnailUrl,
          );

          await FirebaseFirestore.instance.collection('evenements').doc(evenementId).set({
            'fileType': evenement.fileType,
            'fileUrl': evenement.fileUrl,
            'thumbnailUrl': evenement.thumbnailUrl,
            'title': evenement.title,
            'publishDate': evenement.publishDate,
          });

          emit(AddEvenementsSignUpSuccessState(evenementId: evenementId));
        } else {
          throw Exception("Échec de la génération de la vignette");
        }
      } else {
        throw Exception("Aucun fichier sélectionné");
      }
    } catch (error) {
      debugPrint("Erreur lors de l'ajout de l'événement : $error");
      emit(AddEvenementsSignUpErrorState(error: error.toString()));
    }
  }

  Future<String> _uploadFile(File file, String evenementId) async {
    Reference fileRef = _firebaseStorage.ref().child('evenement/$evenementId/file.pdf');
    await fileRef.putFile(file);
    return await fileRef.getDownloadURL();
  }

  Future<String> _uploadThumbnail(Uint8List thumbnail, String evenementId) async {
    Reference thumbnailRef = _firebaseStorage.ref().child('evenement/$evenementId/thumbnail.jpg');
    await thumbnailRef.putData(thumbnail);
    return await thumbnailRef.getDownloadURL();
  }
}
