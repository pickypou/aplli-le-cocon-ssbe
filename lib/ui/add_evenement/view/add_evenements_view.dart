import 'dart:io';

import 'package:app_lecocon_ssbe/ui/comon/widgets/buttoms/custom_buttom.dart';
import 'package:app_lecocon_ssbe/ui/comon/widgets/inputs/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../add_evenement_bloc.dart';
import '../add_evenement_event.dart';
import '../add_evenement_state.dart';

class AddEvenementView extends StatefulWidget {
  const AddEvenementView({super.key});

  @override
  AddEvenementViewState createState() => AddEvenementViewState();
}

class AddEvenementViewState extends State<AddEvenementView> {
  final titleController = TextEditingController();
  File? selectedFile;
  String? fileType;

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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocConsumer<AddEvenementsBloc, AddEvenementsState>(
              listener: (context, state) {
                if (state is AddEvenementsSignUpSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Événement ajouté avec succès')),
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
                    const SizedBox(
                      height: 25,
                    ),
                    CustomButton(
                      onPressed: () async {
                        await _pickFile();
                        setState(
                            () {}); // Met à jour l'interface après sélection
                      },
                      label: 'Choisir un fichier (PDF ou image)',
                    ),
                    if (selectedFile != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Fichier sélectionné : ${selectedFile!.path}',
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: 20),
                    CustomButton(
                      onPressed: () {
                        if (selectedFile != null &&
                            titleController.text.isNotEmpty) {
                          context.read<AddEvenementsBloc>().add(
                                AddEvenementSignUpEvent(
                                  file: selectedFile!,
                                  fileType: fileType!,
                                  id: '', // ID généré côté Firestore ou Bloc
                                  title: titleController.text,
                                  publishDate: DateTime.now(),
                                  thumbnail:
                                      null, // Remplacez par la miniature si elle est générée
                                ),
                              );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Veuillez remplir tous les champs et choisir un fichier.'),
                            ),
                          );
                        }
                      },
                      label: 'Ajouter l\'événement',
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null && result.files.isNotEmpty) {
      selectedFile = File(result.files.first.path!);
      fileType = result.files.first.extension;
      debugPrint("Fichier sélectionné : ${selectedFile!.path}");
      debugPrint("Type de fichier : $fileType");
    } else {
      debugPrint("Aucun fichier sélectionné.");
      selectedFile = null;
      fileType = null;
    }
  }
}
