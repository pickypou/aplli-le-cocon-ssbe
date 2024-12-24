import 'package:app_lecocon_ssbe/data/repository/avis_clients_repository_impl.dart';
import 'package:app_lecocon_ssbe/domain/usecases/fetch_avis_clients_data_usecase.dart';
import 'package:app_lecocon_ssbe/ui/avis_clients_list/avis_clients_list_bloc.dart';
import 'package:app_lecocon_ssbe/ui/ui_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../core/di/di.dart';
import 'avis_clients_list_interactor.dart';
import 'avis_clients_list_view/avis_clients_list_view.dart';

@singleton
class AvisClientsListModule implements UIModule {
  final AppRouter _appRouter;

  AvisClientsListModule(this._appRouter);

  @override
  void configure() {
    _appRouter.addRoutes(getRoutes());
  }

  @override
  List<RouteBase> getRoutes() {
    return [
      GoRoute(
          path: '/avisClientsList',
          pageBuilder: (context, state) {
            return MaterialPage(
              child: _buildAvisClientsList(),
            );
          })
    ];
  }

  @override
  Map<String, WidgetBuilder> getSharedWidgets() {
    return {};
  }

  Widget _buildAvisClientsList() {
    return BlocProvider<AvisClientsListBloc>(
      create: (context) {
        AvisClientsRepositoryImpl avisClientsRepositoryImpl =
            getIt<AvisClientsRepositoryImpl>();
        FetchAvisClientDataUseCase fetchAvisClientsDataUsecase =
            getIt<FetchAvisClientDataUseCase>();
        final String avisClientsId = '';
        var avisClientListInteractor = AvisClientsListInteractor();

        return AvisClientsListBloc(avisClientListInteractor,
            avisClientsId: avisClientsId);
      },
      child: AvisClientsListView(),
    );
  }
}
