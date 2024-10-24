

import 'package:app_lecocon_ssbe/ui/ui_module.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

@singleton
class HomeModule implements UIModule {
  final AppRouter _appRouter;
  HomeModule(this._appRouter);

  @override
  void configure() {
    _appRouter.addRoutes(getRoutes());
  }
  @override
  List<RouteBase> getRoutes()  {
    return [
      GoRoute(
          path: '/',
      builder: (context, state) => const HomePage(),
    )
    ];
  }

  @override
  Map<String, WidgetBuilder> getSharedWidgets() {
    // Implémentation de la méthode manquante
    return {};
  }
}