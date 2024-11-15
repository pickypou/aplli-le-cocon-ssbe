import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EvenementListView extends StatelessWidget {
  const EvenementListView({Key? key}) : super(key: key);

  Future<void> deleteEvent(BuildContext context, String eventId) async {
    try {
      // Afficher un indicateur de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Suppression du fichier dans Storage
      try {
        await FirebaseStorage.instance.ref('evenement/$eventId').delete();
        print('Fichier associé supprimé avec succès');
      } catch (storageError) {
        // Fichier peut ne pas exister, ignorer cette erreur
        print('Erreur lors de la suppression du fichier Storage : $storageError');
      }

      // Suppression du document dans Firestore
      await FirebaseFirestore.instance.collection('evenement').doc(eventId).delete();
      print('Événement supprimé avec succès');

      // Cacher le dialogue après la suppression réussie
      Navigator.of(context).pop();
    } catch (e) {
      // Afficher une erreur et fermer le dialogue
      Navigator.of(context).pop();
      print('Erreur lors de la suppression : $e');
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
      appBar: AppBar(title: const Text('Liste des événements')),
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

          return ListView.builder(
            itemCount: evenements.length,
            itemBuilder: (context, index) {
              final doc = evenements[index];
              return ListTile(
                title: Text(doc['title']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () => _confirmDelete(context, doc.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

