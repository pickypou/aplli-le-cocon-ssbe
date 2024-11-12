import 'package:app_lecocon_ssbe/ui/add_avis_clients/add_avis_clients_module.dart';
import 'package:app_lecocon_ssbe/ui/add_evenement/evenement_module.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../HomePage/home_module.dart';
import '../../account/account_module.dart';
import '../../login/login_module.dart';

@singleton
class AppRouterConfig {
  final AccountModule _accountModule;
  final HomeModule _homeModule;
  final EvenementModule _evenementModule;
  final LoginModule _loginModule;
  final AddAvisClientsModule _addAvisClientsModule;

  // Injection des modules via le constructeur
  AppRouterConfig(this._accountModule, this._homeModule, this._evenementModule,
      this._loginModule, this._addAvisClientsModule);

  GoRouter get router => GoRouter(
        routes: [
          // Intégrez les routes du module de compte
          ..._accountModule.getRoutes(),
          // Intégrez les routes du module d'accueil
          ..._homeModule.getRoutes(),

          ..._evenementModule.getRoutes(),
          ..._loginModule.getRoutes(),
          ..._addAvisClientsModule.getRoutes()
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
