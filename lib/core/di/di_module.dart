import 'package:app_lecocon_ssbe/core/di/api/auth_service.dart';
import 'package:app_lecocon_ssbe/core/di/api/firebase_client.dart';
import 'package:app_lecocon_ssbe/core/di/api/firestore_service.dart';
import 'package:app_lecocon_ssbe/core/di/api/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

@module
abstract class FirebaseModule {
  @singleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @singleton
  FirebaseStorage get storage => FirebaseStorage.instance;

  // Retire l'enregistrement de FirestoreService ici
  // @singleton
  // FirestoreService get firestoreService => FirestoreService();

  @singleton
  StorageService get storageService => StorageService(storage);
}

void setupDi() {
  // Enregistre FirebaseAuth
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  // Enregistre FirebaseFirestore
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  // Enregistre FirebaseStorage
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  // Enregistre FirestoreService avec FirebaseFirestore comme argument
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService(getIt<FirebaseFirestore>()));

  // Enregistre tes autres services
  getIt.registerLazySingleton<FirebaseClient>(() => FirebaseClient());
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<FirebaseAuth>()));
  getIt.registerLazySingleton<StorageService>(() => StorageService(getIt<FirebaseStorage>()));
}
