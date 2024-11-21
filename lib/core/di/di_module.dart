import 'package:app_lecocon_ssbe/core/di/api/auth_service.dart';
import 'package:app_lecocon_ssbe/core/di/api/firestore_service.dart';
import 'package:app_lecocon_ssbe/core/di/api/storage_service.dart';
import 'package:app_lecocon_ssbe/data/repository/avis_client_repository.dart';
import 'package:app_lecocon_ssbe/data/repository/avis_clients_repository_impl.dart';
import 'package:app_lecocon_ssbe/data/repository/evenement_repository.dart';
import 'package:app_lecocon_ssbe/data/repository/evenement_repository_impl.dart';
import 'package:app_lecocon_ssbe/ui/add_avis_clients/add_avis_clients_module.dart';
import 'package:app_lecocon_ssbe/ui/add_evenement/evenement_module.dart';
import 'package:app_lecocon_ssbe/ui/evenement_list/evenement_list_module.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/add_user_module.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../data/repository/users_repository.dart';
import '../../data/repository/users_repository_impl.dart';
import '../../domain/usecases/fetch_evenement_data_usecase.dart';
import '../../ui/HomePage/home_module.dart';
import '../../ui/account/account_module.dart';
import '../../ui/add_evenement/add_evenements_interactor.dart';
import '../../ui/common/router/router_config.dart';
import '../../ui/ui_module.dart';
import '../../ui/users/login/login_module.dart';

// Initialisation de GetIt
final GetIt getIt = GetIt.instance;

// Module pour les services Firebase
@module
abstract class FirebaseModule {
  @singleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @singleton
  FirebaseStorage get storage => FirebaseStorage.instance;

  @singleton
  StorageService get storageService => StorageService(storage);

  @singleton
  UsersRepository get usersRepository => UsersRepositoryImpl();

  @singleton
  AvisClientsRepository get avisClientRepository => AvisClientsRepositoryImpl();

  @singleton
  EvenementsRepository get evenementsRepository => EvenementsRepositoryImpl(
      getIt<FirestoreService>(),
      getIt<FirebaseFirestore>(),
      getIt<FirebaseStorage>());

  @singleton
  EvenementsInteractor get evenementInteractor => EvenementsInteractor(
    getIt<EvenementsRepository>(), // Injection de l'interface
    getIt<FetchEvenementDataUseCase>(),
    getIt<FirebaseStorage>(),
    getIt<FirebaseFirestore>(),
  );
}

void setupDi() {
  // Enregistre les instances Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  // Enregistre les services
  getIt.registerLazySingleton<AuthService>(
      () => AuthService(getIt<FirebaseAuth>()));
  getIt.registerLazySingleton<StorageService>(
      () => StorageService(getIt<FirebaseStorage>()));

  getIt.registerLazySingleton<AppRouter>(() => AppRouter());

  // Enregistre les modules de l'interface utilisateur
  getIt.registerLazySingleton<AccountModule>(
      () => AccountModule(getIt<AppRouter>()));
  getIt.registerLazySingleton<HomeModule>(() => HomeModule(getIt<AppRouter>()));
  getIt.registerLazySingleton<EvenementModule>(
      () => EvenementModule(getIt<AppRouter>()));
  getIt.registerLazySingleton<LoginModule>(
      () => LoginModule(getIt<AppRouter>()));
  getIt.registerLazySingleton<AddAvisClientsModule>(
      () => AddAvisClientsModule(getIt<AppRouter>()));
  getIt.registerLazySingleton<EvenementListModule>(
      () => EvenementListModule(getIt<AppRouter>()));
  getIt.registerLazySingleton<AddUserModule>(
      () => AddUserModule(getIt<AppRouter>()));

  // Enregistre la configuration du routeur avec les modules appropriés
  getIt.registerLazySingleton<AppRouterConfig>(() => AppRouterConfig(
      getIt<AccountModule>(),
      getIt<HomeModule>(),
      getIt<EvenementModule>(),
      getIt<LoginModule>(),
      getIt<AddAvisClientsModule>(),
      getIt<EvenementListModule>(),
      getIt<AddUserModule>()));
}
