import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_lecocon_ssbe/ui/add_evenement/bloc/add_evenement_bloc.dart';
import 'package:app_lecocon_ssbe/ui/add_evenement/bloc/add_evenement_state.dart';

import '../../../theme.dart';
import '../bloc/add_evenement_event.dart';

class AddEvenementView extends StatefulWidget {
  const AddEvenementView({super.key});



  @override
  AddEvenementViewState createState() => AddEvenementViewState();
}

class AddEvenementViewState extends State<AddEvenementView> {
  File? file;
  String? fileType;
  String?fileUrl;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile platformFile = result.files.first;
      setState(() {
        file = File(platformFile.path!);
        fileType = platformFile.extension;
      });
    } else {
      setState(() {
        file = null;
        fileType = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddEvenementsBloc, AddEvenementsState>(
      listener: (context, state) {
        if (state is AddEvenementsSignUpSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Événement ajouté avec succès')),
          );
        } else if (state is AddEvenementsSignUpErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child:Text( 'Choisir un fichier (PDF ou image)',style: textStyleText(context),
              ),

        ),
            if (file != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Fichier sélectionné : ${file!.path}',
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (file != null && fileType != null) {
                  // Déclencher l'événement pour uploader le fichier
                  context.read<AddEvenementsBloc>().add(
                    AddEvenementButtonPressed(
                      file: file!,
                      fileType: fileType!,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez choisir un fichier')),
                  );
                }
              },
              child: const Text('Uploader l\'événement'),
            )



          ],
        );
      },
    );
  }
}