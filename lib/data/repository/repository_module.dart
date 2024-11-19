import 'package:app_lecocon_ssbe/core/di/api/firestore_service.dart';
import 'package:app_lecocon_ssbe/data/repository/avis_client_repository.dart';
import 'package:app_lecocon_ssbe/data/repository/avis_clients_repository_impl.dart';
import 'package:app_lecocon_ssbe/data/repository/evenement_repository.dart';
import 'package:app_lecocon_ssbe/data/repository/evenement_repository_impl.dart';
import 'package:app_lecocon_ssbe/data/repository/users_repository.dart';
import 'package:app_lecocon_ssbe/data/repository/users_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupDataModule() {
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  // Pass the FirebaseFirestore instance to the FirestoreService
  getIt.registerLazySingleton<FirestoreService>(
      () => FirestoreService(getIt<FirebaseFirestore>()));

  getIt.registerLazySingleton<AvisClientsRepository>(
      () => AvisClientsRepositoryImpl());

  getIt.registerLazySingleton<EvenementsRepository>(() =>
      EvenementsRepositoryImpl(getIt<FirestoreService>(),
          getIt<FirebaseFirestore>(), getIt<FirebaseStorage>()));

  getIt.registerLazySingleton<UsersRepository>(() => UsersRepositoryImpl());
}
