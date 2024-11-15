import 'package:app_lecocon_ssbe/data/repository/evenement_repository_impl.dart';
import 'package:app_lecocon_ssbe/domain/usecases/fetch_evenement_data_usecase.dart';
import 'package:app_lecocon_ssbe/ui/evenement_list/evenement_list_bloc.dart';
import 'package:app_lecocon_ssbe/ui/evenement_list/evenement_list_interactor.dart';
import 'package:app_lecocon_ssbe/ui/evenement_list/evenement_list_view/evenement_list_view.dart';
import 'package:app_lecocon_ssbe/ui/ui_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../core/di/di.dart';

@singleton
class EvenementListModule implements UIModule {
  final AppRouter _appRouter;

  EvenementListModule(this._appRouter);

  @override
  void configure() {
    _appRouter.addRoutes(getRoutes());
  }

  @override
  List<RouteBase> getRoutes() {
    return [
      GoRoute(
          path: '/evenementList',
          pageBuilder: (context, state) {
            return MaterialPage(
              child: _buildEvenementList(),
            );
          })
    ];
  }

  @override
  Map<String, WidgetBuilder> getSharedWidgets() {
    return {};
  }

  Widget _buildEvenementList() {
    return BlocProvider<EvenementListBloc>(
      create: (context) {
        EvenementsRepositoryImpl evenementsRepository =
            getIt<EvenementsRepositoryImpl>();
        FetchEvenementDataUseCase fetchEvenementDataUseCase =
            getIt<FetchEvenementDataUseCase>();
        final String evenementId = '';
        var interactor = EvenementListInteractor(
            fetchEvenementDataUseCase, evenementsRepository);

        return EvenementListBloc(interactor, evenementId: evenementId);
      },
      child: EvenementListView(),
    );
  }
}
