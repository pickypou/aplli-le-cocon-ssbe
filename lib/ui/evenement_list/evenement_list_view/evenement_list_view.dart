import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../theme.dart';
import '../evenement_list_interactor.dart';

class EvenementListView extends StatelessWidget {
  const EvenementListView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = GetIt.instance<FirebaseAuth>();
    final firestore = GetIt.instance<FirebaseFirestore>();

    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('evenements').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('Aucun événement trouvé.');
        }

        final evenements = snapshot.data!.docs;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Je supprime un événement'),
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
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: evenements.length,
              itemBuilder: (context, index) {
                final evenement = evenements[index];
                final evenementId = evenement.id;

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: theme.colorScheme.onPrimary)
                              .copyWith(width: 2),
                        ),
                        child: ListTile(
                          title: Wrap(
                            children: [
                              Text(evenement['title'] as String,
                                  style: textStyleText(context)),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final interactor =
                                      context.read<EvenementListInteractor>();
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirmer la suppression'),
                                        content: Text(
                                            'Êtes-vous sûr de vouloir supprimer cet événement ?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Annuler'),
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                          ),
                                          TextButton(
                                            child: Text('Supprimer'),
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    await interactor
                                        .removeEvenement(evenementId);
                                    debugPrint('Événement supprimé');
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
