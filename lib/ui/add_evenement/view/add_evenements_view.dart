import 'package:app_lecocon_ssbe/ui/comon/widgets/inputs/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../ad_vignette_pdf.dart';
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
  final controller = AddEvenementController();

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
                ElevatedButton(
                  onPressed: () async {
                    await controller.pickFile();
                    setState(() {}); // Met à jour l'interface
                  },
                  child: const Text('Choisir un fichier (PDF ou image)'),
                ),
                if (controller.file != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Fichier sélectionné : ${controller.file!.path}',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (controller.file != null &&
                        titleController.text.isNotEmpty) {
                      debugPrint(
                          "Préparation de l'ajout de l'événement au Bloc...");
                      debugPrint("Titre : ${titleController.text}");
                      debugPrint(
                          "Chemin du fichier : ${controller.file!.path}");
                      debugPrint("Type de fichier : ${controller.fileType}");
                      debugPrint(
                          "Thumbnail : ${controller.thumbnail != null ? "Générée" : "Non générée"}");

                      context.read<AddEvenementsBloc>().add(
                            AddEvenementSignUpEvent(
                              file: controller.file!,
                              fileType: controller.fileType!,
                              id: '',
                              title: titleController.text,
                              fileUrl:
                                  '', // Placeholder pour l'URL du fichier après upload
                              publishDate: DateTime.now(),
                              thumbnail: controller
                                  .thumbnail, // Ajout de la miniature ici
                            ),
                          );
                    } else {
                      debugPrint("Échec de la soumission : Champs manquants.");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Veuillez remplir tous les champs et choisir un fichier.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Ajouter l\'événement'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
