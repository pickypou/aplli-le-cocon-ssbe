import 'dart:typed_data';

import 'package:app_lecocon_ssbe/ui/add_evenement/add_evenements_interactor.dart';
import 'package:app_lecocon_ssbe/ui/common/widgets/inputs/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entity/evenements.dart';
import '../../../theme.dart';
import '../../common/widgets/buttoms/custom_buttom.dart';

class AddEvenementView extends StatefulWidget {
  const AddEvenementView({super.key});

  @override
  AddEvenementViewState createState() => AddEvenementViewState();
}

class AddEvenementViewState extends State<AddEvenementView> {
  final titleController = TextEditingController();
  Uint8List? selectedFileBytes;
  String? fileName;
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/account');
          },
        ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Je crée un événement',
                  style: titleStyleLarge(context),
                ),
              ),
              const SizedBox(height: 35),
              CustomTextField(
                controller: titleController,
                labelText: 'Titre de l\'événement',
                maxLines: 1,
              ),
              const SizedBox(height: 35),
              CustomButton(
                onPressed: _pickFile,
                label: 'Choisir un fichier',
              ),
              const SizedBox(height: 20),
              if (selectedFileBytes != null) _buildFilePreview(),
              const SizedBox(height: 35),
              CustomButton(
                onPressed: _isValidInput() ? _addEvent : null,
                label: 'Ajouter l\'événement',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    final evenementsInteractor = EvenementsInteractor();

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          selectedFileBytes = result.files.first.bytes;
          fileName = result.files.first.name;
          String extension = result.files.first.extension?.toLowerCase() ?? '';

          if (extension == 'pdf') {
            fileType = 'pdf';
          } else if (['png', 'jpg', 'jpeg'].contains(extension)) {
            fileType = 'image';
          } else {
            throw Exception('Type de fichier non supporté');
          }
        });
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

  Widget _buildFilePreview() {
    return Column(
      children: [
        Text('Fichier sélectionné : $fileName'),
        const SizedBox(height: 10),
        if (fileType == 'pdf')
          Container(
            height: 150,
            width: 150,
            color: Colors.grey[300],
            child: const Center(child: Text('Aperçu PDF indisponible')),
          )
        else if (fileType == 'image')
          Image.memory(
            selectedFileBytes!,
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          ),
      ],
    );
  }

  bool _isValidInput() {
    return selectedFileBytes != null && titleController.text.isNotEmpty;
  }

  Future<void> _addEvent() async {
    final interactor = EvenementsInteractor();

    if (_isValidInput() && selectedFileBytes != null) {
      try {
        final uploadResult = await interactor.uploadFileWithThumbnail(
          selectedFileBytes!,
          fileName!,
          fileType!,
          DateTime.now().millisecondsSinceEpoch.toString(),
        );

        final evenement = Evenement(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: titleController.text,
          fileUrl: uploadResult['fileUrl']!,
          thumbnailUrl: uploadResult['thumbnailUrl']!,
          fileType: fileType!,
          publishDate: DateTime.now(),
        );

        await interactor.addEvenement(evenement);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Événement ajouté avec succès')),
        );

        context.go('/account'); // Redirection après succès
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    }
  }
}
