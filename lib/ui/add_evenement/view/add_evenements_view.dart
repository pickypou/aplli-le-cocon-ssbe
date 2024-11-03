import 'dart:io';
import 'package:app_lecocon_ssbe/ui/comon/widgets/created_miniature/created_miniature.dart';
import 'package:app_lecocon_ssbe/ui/comon/widgets/inputs/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_lecocon_ssbe/ui/add_evenement/add_evenement_bloc.dart';
import 'package:app_lecocon_ssbe/ui/add_evenement/add_evenement_state.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../theme.dart';
import '../add_evenement_event.dart';

class AddEvenementView extends StatefulWidget {
  const AddEvenementView({super.key});

  @override
  AddEvenementViewState createState() => AddEvenementViewState();
}

class AddEvenementViewState extends State<AddEvenementView> {
  final titleController = TextEditingController();
  File? file;
  String? fileType;
  String? fileUrl;
  File? thumbnail;
   String pdfUrl = '';

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

      // Générer la miniature sans l'afficher
      thumbnail = (await PdfMiniature(pdfUrl: pdfUrl,)) as File?;
    } else {
      setState(() {
        file = null;
        fileType = null;
        thumbnail = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = GetIt.instance<FirebaseAuth>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('J\'ajoute un événement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              auth.signOut().then((_) {
                debugPrint('Déconnexion réussie');
                context.go('/');
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AddEvenementsBloc, AddEvenementsState>(
          listener: (context, state) {
            if (state is AddEvenementsSignUpSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Événement ajouté avec succès')),
              );
              GoRouter.of(context).go('/account');
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
                CustomTextField(
                  controller: titleController,
                  labelText: 'Titre de l\'événement',
                  maxLines: 2,
                ),
                CustomTextField(
                  labelText: 'Nom du fichier',
                  maxLines: 2,
                ),
                ElevatedButton(
                  onPressed: pickFile,
                  child: Text(
                    'Choisir un fichier (PDF ou image)',
                    style: textStyleText(context),
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
                      context.read<AddEvenementsBloc>().add(
                        AddEvenementSignUpEvent(
                          file: file!,
                          fileType: fileType!,
                          id: '',
                          title: titleController.text,
                          fileUrl: '',
                          publishDate: DateTime.now(),
                          thumbnail: thumbnail, // Inclure la miniature dans l'événement
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Veuillez choisir un fichier et donner un nom au fichier'),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Envoyer l\'événement',
                    style: textStyleText(context),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}