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
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @lazySingleton
  FirebaseStorage get storage => FirebaseStorage.instance;
}
void setupDi() {
  // Enregistre FirebaseAuth et FirebaseFirestore
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  // Enregistre tes autres services en les injectant
  getIt.registerLazySingleton<FirebaseClient>(() => FirebaseClient());
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<FirebaseAuth>()));
  getIt.registerLazySingleton<StorageService>(() => StorageService(getIt<FirebaseStorage>()));
}