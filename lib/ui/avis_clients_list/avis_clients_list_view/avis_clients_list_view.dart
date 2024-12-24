import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../avis_clients_list_interactor.dart';

class AvisClientsListView extends StatelessWidget {
  final auth = GetIt.instance<FirebaseAuth>();

  AvisClientsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final interactor = AvisClientsListInteractor();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des avis clients'),
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
              auth.signOut().then((_) => context.go('/'));
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('avis_clients').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Aucun avis trouvé.'));
          }

          final evenements = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: evenements.map((doc) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            doc['categories'],
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8.0),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () async {
                              final confirm = await _confirmDelete(context);
                              if (confirm) {
                                try {
                                  await interactor.removeAvisClient(doc.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('avis supprimé avec succès')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Erreur : $e')),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirmer la suppression'),
              content: const Text('Voulez-vous vraiment supprimer cet avis ?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Supprimer'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
