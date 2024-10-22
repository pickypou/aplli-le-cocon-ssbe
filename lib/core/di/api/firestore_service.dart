import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore); // Utilise l'instance passée dans le constructeur

  CollectionReference collection(String path) {
    return _firestore.collection(path);
  }

  Future<void> addData(String collection, Map<String, dynamic> data) async {
    await _firestore.collection(collection).add(data);
  }

  Future<List<Map<String, dynamic>>> getData(String collection) async {
    QuerySnapshot snapshot = await _firestore.collection(collection).get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}

