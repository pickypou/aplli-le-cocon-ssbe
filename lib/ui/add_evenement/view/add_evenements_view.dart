import 'dart:io';

import 'package:app_lecocon_ssbe/ui/comon/widgets/buttoms/custom_buttom.dart';
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
  void dispose() {
    titleController.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
        child: Padding(
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
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Titre de l\'événement',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    onPressed: _pickFile,
                    label: 'Choisir un fichier (PDF ou image)',
                  ),
                  const SizedBox(height: 20),
                  if (selectedFile != null)
                    _buildFilePreview(),
                  const SizedBox(height: 20),
                  CustomButton(
                    onPressed: _isValidInput() ? _addEvent : null,
                    label: 'Ajouter l\'événement',
                  ),
                  if (state is AddEvenementsSignUpLoadingState)
                    const CircularProgressIndicator(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilePreview() {
    return Column(
      children: [
        Text('Fichier sélectionné: ${selectedFile!.path.split('/').last}'),
        const SizedBox(height: 10),
        if (fileType == 'pdf')
          Container(
            height: 150,
            width: 150,
            color: Colors.grey[300],
            child: const Center(child: Text('Aperçu PDF')),
          )
        else if (['png', 'jpg', 'jpeg'].contains(fileType))
          Image.file(
            selectedFile!,
            height: 150,
            width: 150,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 150,
                width: 150,
                color: Colors.red[300],
                child: const Center(child: Text('Erreur de chargement')),
              );
            },
          ),
      ],
    );
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          selectedFile = File(result.files.first.path!);
          // Déterminer le type de fichier basé sur l'extension
          String extension = result.files.first.extension?.toLowerCase() ?? '';
          if (extension == 'pdf') {
            fileType = 'pdf';
          } else if (['png', 'jpg', 'jpeg'].contains(extension)) {
            fileType = 'image';
          } else {
            throw Exception('Type de fichier non supporté');
          }
        });
        debugPrint("Fichier sélectionné : ${selectedFile!.path}");
        debugPrint("Type de fichier : $fileType");
      } else {
        debugPrint("Aucun fichier sélectionné.");
      }
    } catch (e) {
      debugPrint("Erreur lors de la sélection du fichier : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la sélection du fichier')),
      );
    }
  }

  bool _isValidInput() {
    return selectedFile != null && titleController.text.isNotEmpty;
  }

  void _addEvent() {
    if (_isValidInput()) {
      context.read<AddEvenementsBloc>().add(
        AddEvenementSignUpEvent(
          file: selectedFile!,
          fileType: fileType!,
          id: '',
          title: titleController.text,
          publishDate: DateTime.now(),
          thumbnail: null,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un fichier et entrer un titre.'),
        ),
      );
    }
  }
}