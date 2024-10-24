import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import '../../HomePage/home_module.dart';
import '../../account/account_module.dart';

@singleton
class AppRouterConfig {
  final AccountModule _accountModule;
  final HomeModule _homeModule;

  // Injection des modules via le constructeur
  AppRouterConfig(this._accountModule, this._homeModule);

  GoRouter get router => GoRouter(
    routes: [
      // Intégrez les routes du module de compte
      ..._accountModule.getRoutes(),
      // Intégrez les routes du module d'accueil
      ..._homeModule.getRoutes(),
      // Ajoutez d'autres routes de modules ici
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
