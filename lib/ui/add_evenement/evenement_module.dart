


import 'package:app_lecocon_ssbe/core/di/di.dart';
import 'package:app_lecocon_ssbe/data/repository/evenement_repository_impl.dart';
import 'package:app_lecocon_ssbe/domain/usecases/fetch_evenement_data_usecase.dart';
import 'package:app_lecocon_ssbe/ui/add_evenement/add_evenement_bloc.dart';
import 'package:app_lecocon_ssbe/ui/add_evenement/view/add_evenements_view.dart';
import 'package:app_lecocon_ssbe/ui/ui_module.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'add_evenements_interator.dart';

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
        }

      )
    ];
  }

  Widget _buildEvenementPage() {
  return BlocProvider<AddEvenementsBloc>(
    create: (context) {
      EvenementsRepositoryImpl evenementsRepository = getIt<EvenementsRepositoryImpl>();
      FetchEvenementDataUseCase fetchEvenementDataUseCase = getIt<FetchEvenementDataUseCase>();
      FirebaseStorage storage = getIt<FirebaseStorage>();
      FirebaseFirestore firestore = getIt<FirebaseFirestore>();

      var interactor = EvenementsInteractor(evenementsRepository, fetchEvenementDataUseCase, storage, firestore);
      return AddEvenementsBloc(interactor);
    },

    child: const AddEvenementView(),
  );
  }

  @override
  Map<String, WidgetBuilder> getSharedWidgets() {
    return {};
  }


}