import 'package:app_lecocon_ssbe/core/di/di.dart';
import 'package:app_lecocon_ssbe/data/repository/avis_client_repository.dart';
import 'package:app_lecocon_ssbe/data/repository/avis_clients_repository_impl.dart';
import 'package:app_lecocon_ssbe/domain/usecases/fetch_avis_clients_data_usecase.dart';
import 'package:app_lecocon_ssbe/ui/add_avis_clients/avis_clients_bloc.dart';
import 'package:app_lecocon_ssbe/ui/add_avis_clients/avis_clients_interactor.dart';
import 'package:app_lecocon_ssbe/ui/add_avis_clients/view/add_avis_clients_view.dart';
import 'package:app_lecocon_ssbe/ui/ui_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@singleton
class AddAvisClientsModule implements UIModule {
  final AppRouter _appRouter;

  AddAvisClientsModule(this._appRouter);

  @override
  void configure() {
    _appRouter.addRoutes(getRoutes());
  }

  @override
  List<RouteBase> getRoutes() {
    return [
      GoRoute(
          path: '/addAvisClients',
      pageBuilder: (context, state) {
            return MaterialPage(
                child: _buildAddAvisClients(),
            );
      }
      )
    ];
  }

  @override
  Map<String, WidgetBuilder> getSharedWidgets() {
    return {};
  }

  Widget _buildAddAvisClients() {

    return BlocProvider<AddAvisClientsBloc>(
      create: (context){
        AvisClientsRepository avisClientsRepository = getIt<AvisClientsRepositoryImpl>();
        FetchAvisClientDataUseCase fetchAvisClientDataUseCase = getIt<FetchAvisClientDataUseCase>();
        var interactor = AvisClientsInteractor(avisClientsRepository, fetchAvisClientDataUseCase);

        return AddAvisClientsBloc(interactor);
      },
      child: AddAvisClientsView(),
    );
  }

}