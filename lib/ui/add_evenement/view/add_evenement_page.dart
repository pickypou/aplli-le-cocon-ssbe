import 'package:app_lecocon_ssbe/theme.dart';
import 'package:app_lecocon_ssbe/ui/add_evenement/view/add_evenements_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entity/evenements.dart';

class AddEvenementsPage extends StatelessWidget {
  const AddEvenementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = GetIt.instance<FirebaseAuth>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evénements'),
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Je crée un événement',
                          style: titleStyleLarge(context),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 50),
                        Image.asset(
                          'assets/images/logo_cocon.png',
                          fit: BoxFit.contain,
                          width: constraints.maxWidth / 2,
                        ),
                        const SizedBox(height: 50),
                        Expanded(child: AddEvenementView())
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<List<Evenement>> fetchEvenements() async {
  List<Evenement> evenements = [];
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('evenement')
        .orderBy('publishDate', descending: true)
        .get();

    for (var doc in snapshot.docs) {
      Evenement evt =
          Evenement.fromMap(doc.data() as Map<String, dynamic>, doc.id);

      try {
        final Reference eventRef =
            FirebaseStorage.instance.ref().child('evenement/${evt.id}');
        final Reference fileRef =
            eventRef.child('file.${evt.fileType == 'pdf' ? 'pdf' : 'jpg'}');
        final Reference thumbnailRef = eventRef.child('thumbnail.jpg');

        String fileUrl = await fileRef.getDownloadURL();
        String? thumbnailUrl;

        if (evt.fileType == 'pdf') {
          try {
            thumbnailUrl = await thumbnailRef.getDownloadURL();
          } catch (e) {
            debugPrint('Pas de vignette pour le PDF de l\'événement ${evt.id}');
          }
        } else {
          thumbnailUrl =
              fileUrl; // Pour les images, utiliser le fichier principal comme vignette
        }

        evenements.add(Evenement(
          id: evt.id,
          title: evt.title,
          publishDate: evt.publishDate,
          fileType: evt.fileType,
          fileUrl: fileUrl,
          thumbnailUrl: thumbnailUrl,
        ));
      } catch (e) {
        debugPrint(
            'Erreur lors de la récupération des fichiers pour l\'événement ${evt.id}: $e');
      }
    }
  } catch (e) {
    debugPrint('Erreur lors de la récupération des événements: $e');
  }

  return evenements;
}
