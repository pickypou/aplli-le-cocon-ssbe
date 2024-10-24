import 'package:app_lecocon_ssbe/ui/ui_module.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../../ui/HomePage/home_module.dart';
import '../../ui/account/account_module.dart';
import '../../ui/comon/router/router_config.dart';
import 'api/auth_service.dart';
import 'api/storage_service.dart';
import 'di.config.dart'; // Assurez-vous que ce fichier est bien généré

// Instance de GetIt
final getIt = GetIt.instance;

// Configuration des dépendances
@InjectableInit(
  initializerName: 'init', // Nom de l'initialisateur, par défaut 'init'
  preferRelativeImports: true, // Utilisation d'importations relatives
  asExtension: false, // Pas d'extension
)
void configureDependencies() => init(getIt);

void setupDependencies() {
  try {
    debugPrint("Enregistrement de FirebaseAuth");
    getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

    debugPrint("Enregistrement de FirebaseFirestore");
    getIt.registerLazySingleton<FirebaseFirestore>(() =>
    FirebaseFirestore.instance);

    debugPrint("Enregistrement de FirebaseStorage");
    getIt.registerLazySingleton<FirebaseStorage>(() =>
    FirebaseStorage.instance);

    debugPrint("Enregistrement de AuthService");
    getIt.registerLazySingleton<AuthService>(() =>
        AuthService(getIt<FirebaseAuth>()));

    debugPrint("Enregistrement de StorageService");
    getIt.registerLazySingleton<StorageService>(() =>
        StorageService(getIt<FirebaseStorage>()));

    // Enregistre les modules de l'interface utilisateur
    debugPrint("Enregistrement de AccountModule");
    getIt.registerLazySingleton<AccountModule>(() =>
        AccountModule(getIt<AppRouter>()));

    debugPrint("Enregistrement de HomeModule");
    getIt.registerLazySingleton<HomeModule>(() =>
        HomeModule(getIt<AppRouter>()));

    // Enregistre la configuration du routeur avec les modules appropriés
    debugPrint("Enregistrement de AppRouterConfig");
    getIt.registerLazySingleton<AppRouterConfig>(() =>
        AppRouterConfig(
          getIt<AccountModule>(),
          getIt<HomeModule>(),
        ));

    // Enregistre les modules de l'interface utilisateur
    debugPrint("Enregistrement de AccountModule");
    getIt.registerLazySingleton<AccountModule>(() =>
        AccountModule(getIt<AppRouter>()));

    debugPrint("Enregistrement de HomeModule");
    getIt.registerLazySingleton<HomeModule>(() =>
        HomeModule(getIt<AppRouter>()));
  }catch (e) {
    debugPrint("Erreur lors de l'enregistrement : $e");
  }
}