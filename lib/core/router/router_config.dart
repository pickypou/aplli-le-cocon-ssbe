import 'package:app_lecocon_ssbe/ui/add_avis_clients/add_avis_clients_module.dart';
import 'package:app_lecocon_ssbe/ui/add_evenement/evenement_module.dart';
import 'package:app_lecocon_ssbe/ui/avis_clients_list/avis_clients_list_module.dart';
import 'package:app_lecocon_ssbe/ui/evenement_list/evenement_list_module.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/add_user_module.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/entity_module.dart';
import '../../ui/HomePage/home_module.dart';
import '../../ui/account/account_module.dart';
import '../../ui/users/login/login_module.dart';

@singleton
class AppRouterConfig {
  GoRouter get router => GoRouter(
        routes: [
          ...getIt<AccountModule>().getRoutes(),
          ...getIt<HomeModule>().getRoutes(),
          ...getIt<EvenementModule>().getRoutes(),
          ...getIt<LoginModule>().getRoutes(),
          ...getIt<AddAvisClientsModule>().getRoutes(),
          ...getIt<EvenementListModule>().getRoutes(),
          ...getIt<AddUserModule>().getRoutes(),
          ...getIt<AvisClientsListModule>().getRoutes()
        ],
        errorBuilder: (context, state) => const ErrorPage(),
      );
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    );
  }
}
