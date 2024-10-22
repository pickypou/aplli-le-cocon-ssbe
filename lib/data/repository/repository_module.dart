

import 'package:app_lecocon_ssbe/data/repository/avis_client_repository.dart';
import 'package:app_lecocon_ssbe/data/repository/avis_clients_repository_impl.dart';
import 'package:app_lecocon_ssbe/data/repository/evenement_repository.dart';
import 'package:app_lecocon_ssbe/data/repository/evenement_repository_impl.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupDataModule() {
  getIt.registerLazySingleton<AvisClientsRepository>(() => AvisClientsRepositoryImpl() );

  getIt.registerLazySingleton<EvenementsRepository>(() => EvenementsRepositoryImpl());
}