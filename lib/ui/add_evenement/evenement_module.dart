import 'package:app_lecocon_ssbe/ui/add_evenement/add_evenement_bloc.dart';
import 'package:app_lecocon_ssbe/ui/add_evenement/view/add_evenements_view.dart';
import 'package:app_lecocon_ssbe/ui/ui_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@singleton
class EvenementModule implements UIModule {
  final AppRouter _appRouter;

  EvenementModule(this._appRouter);

  @override
  void configure() {
    _appRouter.addRoutes(getRoutes());
  }

  @override
  List<RouteBase> getRoutes() {
    return [
      GoRoute(
        path: '/evenement',
        pageBuilder: (context, state) {
          return MaterialPage(
            child: _buildEvenementPage(),
          );
        },
      ),
    ];
  }

  Widget _buildEvenementPage() {
    // Créez le TextEditingController ici
    final TextEditingController titleController = TextEditingController();

    return BlocProvider<AddEvenementsBloc>(
      create: (context) {
        return AddEvenementsBloc();
      },
      child: AddEvenementView(),
    );
  }

  @override
  Map<String, WidgetBuilder> getSharedWidgets() {
    return {};
  }
}
