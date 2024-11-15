import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Future<void> deleteEvent(BuildContext context, String eventId) async {
  try {
    // Récupérer les données du document Firestore
    final docSnapshot = await FirebaseFirestore.instance.collection('evenement').doc(eventId).get();

    if (docSnapshot.exists) {
      // Supposons que l'URL du fichier est stockée dans Firestore sous 'fileUrl'
      final fileUrl = docSnapshot.data()?['fileUrl'] as String?;

      if (fileUrl != null) {
        // Supprimer le fichier dans Firebase Storage
        final ref = FirebaseStorage.instance.refFromURL(fileUrl);
        await ref.delete();
        print('Fichier Storage supprimé avec succès');
      }
    }

    // Supprimer le document Firestore
    await FirebaseFirestore.instance.collection('evenement').doc(eventId).delete();
    print('Document Firestore supprimé avec succès');
  } catch (e) {
    print('Erreur lors de la suppression : $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur : Impossible de supprimer l\'événement')),
    );
  }
}
