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
import '../../data/repository/users_repository_impl.dart' as _i304;
import '../../domain/usecases/fetch_avis_clients_data_usecase.dart' as _i57;
import '../../domain/usecases/fetch_evenement_data_usecase.dart' as _i914;
import '../../domain/usecases/fetch_user_data_usecase.dart' as _i656;
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
  gh.singleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
  gh.singleton<_i457.FirebaseStorage>(() => firebaseModule.storage);
  gh.singleton<_i717.StorageService>(() => firebaseModule.storageService);
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
  gh.factory<_i746.FirestoreService>(
      () => _i746.FirestoreService(gh<_i974.FirebaseFirestore>()));
  gh.factoryParam<_i1053.EvenementsRepositoryImpl, _i974.FirebaseFirestore?,
      dynamic>((
    firestore,
    _,
  ) =>
      _i1053.EvenementsRepositoryImpl(
        gh<_i746.FirestoreService>(),
        firestore,
      ));
  gh.factory<_i656.FetchUserDataUseCase>(() => _i656.FetchUserDataUseCase(
        gh<String>(),
        gh<_i304.UsersRepositoryImpl>(),
      ));
  return getIt;
}

class _$FirebaseModule extends _i211.FirebaseModule {}
