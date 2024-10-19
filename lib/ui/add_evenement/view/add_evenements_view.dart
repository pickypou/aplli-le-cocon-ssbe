import 'dart:io';
import 'package:app_lecocon_ssbe/ui/comon/widgets/buttoms/custom_buttom.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_lecocon_ssbe/ui/add_evenement/bloc/add_evenement_bloc.dart';
import 'package:app_lecocon_ssbe/ui/add_evenement/bloc/add_evenement_event.dart';
import 'package:app_lecocon_ssbe/ui/add_evenement/bloc/add_evenement_state.dart';

import '../../../theme.dart';

class AddEvenementView extends StatefulWidget {
  const AddEvenementView({super.key});



  @override
  AddEvenementViewState createState() => AddEvenementViewState();
}

class AddEvenementViewState extends State<AddEvenementView> {
  File? file;
  String? fileType;

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
            CustomButton(
              onPressed: pickFile,
              label: 'Choisir un fichier (PDF ou image)',
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
            CustomButton(
              onPressed: state is AddEvenementsSignUpLoadingState
                  ? null
                  : () {
                if (file != null && fileType != null) {
                  context.read<AddEvenementsBloc>().add(
                    AddEvenementSignUpEvent(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      file: file!,
                      fileType: fileType!,
                      publishDate: DateTime.now(),
                      fileUrl: '',
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Veuillez choisir un fichier',
                        style: textStyleText(context),
                      ),
                    ),
                  );
                }
              },
              label: state is AddEvenementsSignUpLoadingState
                  ? 'Chargement...' // Texte pendant le chargement
                  : 'Créer l\'événement', // Texte par défaut
            ),



          ],
        );
      },
    );
  }
}