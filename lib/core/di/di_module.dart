import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

import '../../core/di/di.dart';
import '../../data/repository/repository_module.dart';
import '../../domain/domain_module.dart';
import '../../ui/HomePage/home_module.dart';
import '../../ui/account/account_module.dart';
import '../../ui/add_avis_clients/add_avis_clients_module.dart';
import '../../ui/add_evenement/evenement_module.dart';
import '../../ui/common/router/router_config.dart';
import '../../ui/evenement_list/evenement_list_module.dart';
import '../../ui/ui_module.dart';
import '../../ui/users/add_users/add_user_module.dart';
import '../../ui/users/login/login_module.dart';
import 'api/auth_service.dart';
import 'api/storage_service.dart';

@module
abstract class FirestoreModule {
  @lazySingleton
  FirebaseFirestore get firebaseFirestore => FirebaseFirestore.instance;

  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;

  @singleton
  StorageService get storageService => StorageService(getIt<FirebaseStorage>());

  @singleton
  AuthService get authService => AuthService(getIt<FirebaseAuth>());
  @singleton
  AppRouter get appRouter => AppRouter();

  @singleton
  AccountModule get accountModule => AccountModule(appRouter);

  @singleton
  HomeModule get homeModule => HomeModule(appRouter);

  @singleton
  EvenementModule get evenementModule => EvenementModule(appRouter);

  @singleton
  LoginModule get loginModule => LoginModule(appRouter);

  @singleton
  AddAvisClientsModule get addAvisClientsModule =>
      AddAvisClientsModule(appRouter);

  @singleton
  EvenementListModule get evenementListModule => EvenementListModule(appRouter);

  @singleton
  AddUserModule get addUserModule => AddUserModule(appRouter);

  @singleton
  AppRouterConfig get appRouterConfig => AppRouterConfig(
        accountModule,
        homeModule,
        evenementModule,
        loginModule,
        addAvisClientsModule,
        evenementListModule,
        addUserModule,
      );

  @postConstruct
  void init() {
    setupDataModule();
    setupDomainModule();
  }
}
