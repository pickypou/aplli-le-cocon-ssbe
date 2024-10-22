import 'package:app_lecocon_ssbe/domain/entity/entity_module.dart';
import 'package:app_lecocon_ssbe/domain/usecases/usecase_module.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupDomainModule() {
  // Setup des entités
  setupEntityModule();

  //Setupt des Use Case

  setupUseCaseModule();





}
