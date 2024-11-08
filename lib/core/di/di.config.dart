// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/repository/avis_client_repository.dart' as _i684;
import '../../data/repository/avis_clients_repository_impl.dart' as _i552;
import '../../data/repository/evenement_repository.dart' as _i590;
import '../../data/repository/evenement_repository_impl.dart' as _i1053;
import '../../data/repository/users_repository.dart' as _i151;
import '../../data/repository/users_repository_impl.dart' as _i304;
import '../../domain/usecases/fetch_avis_clients_data_usecase.dart' as _i57;
import '../../domain/usecases/fetch_evenement_data_usecase.dart' as _i914;
import '../../domain/usecases/fetch_user_data_usecase.dart' as _i656;
import '../../domain/usecases/generate_and_upload_thumbnail_use_case.dart'
    as _i700;
import '../../ui/account/account_module.dart' as _i692;
import '../../ui/add_avis_clients/add_avis_clients_module.dart' as _i356;
import '../../ui/add_evenement/evenement_module.dart' as _i402;
import '../../ui/comon/router/router_config.dart' as _i686;
import '../../ui/HomePage/home_module.dart' as _i587;
import '../../ui/ui_module.dart' as _i573;
import '../../ui/users/add_users/inscription/add_user_module.dart' as _i966;
import '../../ui/users/login/login_module.dart' as _i863;
import 'api/auth_service.dart' as _i977;
import 'api/firebase_client.dart' as _i703;
import 'api/firestore_service.dart' as _i746;
import 'api/storage_service.dart' as _i717;
import 'di_module.dart' as _i211;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final firebaseModule = _$FirebaseModule();
  gh.factory<_i703.FirebaseClient>(() => _i703.FirebaseClient());
  gh.factory<_i590.EvenementsRepository>(
      () => firebaseModule.evenementsRepository);
  gh.factory<_i700.GenerateThumbnailUseCase>(
      () => _i700.GenerateThumbnailUseCase());
  gh.singleton<_i573.AppRouter>(() => _i573.AppRouter());
  gh.singleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
  gh.singleton<_i457.FirebaseStorage>(() => firebaseModule.storage);
  gh.singleton<_i717.StorageService>(() => firebaseModule.storageService);
  gh.singleton<_i151.UsersRepository>(() => firebaseModule.usersRepository);
  gh.singleton<_i684.AvisClientsRepository>(
      () => firebaseModule.avisClientRepository);
  gh.factory<_i552.AvisClientsRepositoryImpl>(() =>
      _i552.AvisClientsRepositoryImpl(
          firestore: gh<_i974.FirebaseFirestore>()));
  gh.factory<_i914.FetchEvenementDataUseCase>(
      () => _i914.FetchEvenementDataUseCase(gh<_i590.EvenementsRepository>()));
  gh.factory<_i304.UsersRepositoryImpl>(() => _i304.UsersRepositoryImpl(
        firestore: gh<_i974.FirebaseFirestore>(),
        auth: gh<_i59.FirebaseAuth>(),
      ));
  gh.factory<_i57.FetchAvisClientDataUseCase>(
      () => _i57.FetchAvisClientDataUseCase(gh<_i684.AvisClientsRepository>()));
  gh.factory<_i977.AuthService>(
      () => _i977.AuthService(gh<_i59.FirebaseAuth>()));
  gh.singleton<_i402.EvenementModule>(
      () => _i402.EvenementModule(gh<_i573.AppRouter>()));
  gh.singleton<_i863.LoginModule>(
      () => _i863.LoginModule(gh<_i573.AppRouter>()));
  gh.singleton<_i966.AddUserModule>(
      () => _i966.AddUserModule(gh<_i573.AppRouter>()));
  gh.singleton<_i356.AddAvisClientsModule>(
      () => _i356.AddAvisClientsModule(gh<_i573.AppRouter>()));
  gh.singleton<_i587.HomeModule>(() => _i587.HomeModule(gh<_i573.AppRouter>()));
  gh.singleton<_i692.AccountModule>(
      () => _i692.AccountModule(gh<_i573.AppRouter>()));
  gh.factory<_i746.FirestoreService>(
      () => _i746.FirestoreService(gh<_i974.FirebaseFirestore>()));
  gh.factory<_i1053.EvenementsRepositoryImpl>(
      () => _i1053.EvenementsRepositoryImpl(
            gh<_i746.FirestoreService>(),
            gh<_i974.FirebaseFirestore>(),
          ));
  gh.singleton<_i686.AppRouterConfig>(() => _i686.AppRouterConfig(
        gh<_i692.AccountModule>(),
        gh<_i587.HomeModule>(),
        gh<_i402.EvenementModule>(),
        gh<_i863.LoginModule>(),
        gh<_i966.AddUserModule>(),
        gh<_i356.AddAvisClientsModule>(),
      ));
  gh.factory<_i656.FetchUserDataUseCase>(() => _i656.FetchUserDataUseCase(
        gh<String>(),
        gh<_i304.UsersRepositoryImpl>(),
      ));
  return getIt;
}

class _$FirebaseModule extends _i211.FirebaseModule {}
