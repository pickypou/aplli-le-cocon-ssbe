


import 'package:app_lecocon_ssbe/domain/entity/users.dart';
import 'package:get_it/get_it.dart';

import 'avis_clients.dart';
import 'evenements.dart';

final GetIt getIt = GetIt.instance;

void setupEntityModule() {
  getIt.registerFactory<AvisClients>(() => AvisClients(
    id: '',  // Provide a default or generate a unique ID
    categories: '',  // Provide default categories or an empty list
    text: '',  // Provide a default text
    publishDate: DateTime.now(),  // Use current date as default
  ));

  //Register evenements
  getIt.registerFactory<Evenements>(() => Evenements(
    id: '',
    title: '',
    fileType: '',
    fileUrl: '',
    publishDate: DateTime.now(),
  ));

  //Register Users
  getIt.registerFactory<Users>(() => Users(
      id: '',
      userName: '',
      email: '',
      password: ''
  ));
}