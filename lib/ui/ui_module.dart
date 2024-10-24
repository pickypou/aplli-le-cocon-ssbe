import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

/// Interface abstraite pour les modules UI
abstract class UIModule {
  /// Méthode pour configurer les routes et autres éléments du module
  void configure();

  /// Méthode pour obtenir les routes du module
  List<RouteBase> getRoutes();

  /// Méthode pour obtenir les widgets partagés du module (si nécessaire)
  Map<String, WidgetBuilder> getSharedWidgets();
}

/// Mixin pour fournir une implémentation par défaut de getSharedWidgets
mixin DefaultSharedWidgets on UIModule {
  @override
  Map<String, WidgetBuilder> getSharedWidgets() {
    return {};
  }
}

/// Classe pour gérer les routes de l'application
@singleton
class AppRouter {
  final List<RouteBase> _routes = [];

  void addRoutes(List<RouteBase> routes) {
    _routes.addAll(routes);
  }

  List<RouteBase> get routes => _routes;
}

/// Fonction pour créer le routeur Go
GoRouter createRouter(AppRouter appRouter) {
  return GoRouter(
    routes: appRouter.routes,
    // Vous pouvez ajouter d'autres configurations ici si nécessaire
  );
}