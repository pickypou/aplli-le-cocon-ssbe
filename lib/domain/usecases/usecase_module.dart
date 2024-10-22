import 'package:app_lecocon_ssbe/data/repository/evenement_repository_impl.dart';
import 'package:app_lecocon_ssbe/data/repository/users_repository_impl.dart';
import 'package:app_lecocon_ssbe/domain/usecases/fetch_evenement_data_usecase.dart';
import 'package:app_lecocon_ssbe/domain/usecases/fetch_user_data_usecase.dart';
import 'package:app_lecocon_ssbe/data/repository/avis_clients_repository_impl.dart';
import 'package:app_lecocon_ssbe/domain/usecases/fetch_avis_clients_data_usecase.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupUseCaseModule() {
  // Enregistrement du cas d'utilisation FetchAvisClientsDataUseCase
  getIt.registerLazySingleton<FetchAvisClientDataUseCase>(
          () => FetchAvisClientDataUseCase(getIt<AvisClientsRepositoryImpl>())
  );
  if (getIt.isRegistered<FetchEvenementDataUseCase>()) {
    getIt.unregister<FetchEvenementDataUseCase>();
  }
  // Enregistrement du cas d'utilisation FetchEvenementDataUseCase
  getIt.registerLazySingleton<FetchEvenementDataUseCase>(
          () => FetchEvenementDataUseCase(getIt<EvenementsRepositoryImpl>())
  );

  // Enregistrement du cas d'utilisation FetchUserDataUseCase avec un userId dynamique
  getIt.registerFactoryParam<FetchUserDataUseCase, String, void>(
          (userId, _) => FetchUserDataUseCase(userId, getIt<UsersRepositoryImpl>())
  );
}
