import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class EvenementListView extends StatelessWidget {
  final auth = GetIt.instance<FirebaseAuth>();

  EvenementListView({super.key});

  Future<void> deleteEvent(BuildContext context, String eventId) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        await FirebaseStorage.instance.ref('evenement/$eventId').delete();
      } catch (storageError) {
        print('Erreur lors de la suppression du fichier Storage : $storageError');
      }

      await FirebaseFirestore.instance.collection('evenement').doc(eventId).delete();
      Navigator.of(context).pop();
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : Impossible de supprimer l\'événement')),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, String eventId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: const Text('Voulez-vous vraiment supprimer cet événement ?'),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: const Text('Supprimer'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await deleteEvent(context, eventId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des événements'),
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
                context.go('/');
              });
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('evenement').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Aucun événement trouvé.'));
          }

          final evenements = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0, // Espacement horizontal entre les cartes
              runSpacing: 8.0, // Espacement vertical entre les cartes
              children: evenements.map((doc) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45, // Largeur des cartes
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
                            doc['title'],
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
                            onPressed: () => _confirmDelete(context, doc.id),
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
}
