
import 'package:app_lecocon_ssbe/ui/users/add_users/view/add_user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../../core/di/di.dart';
import '../../../data/repository/users_repository.dart';
import '../../ui_module.dart';
import 'add_user_bloc.dart';
import 'add_user_interactor.dart';

@singleton
class AddUserModule implements UIModule {
  final AppRouter _appRouter;
  AddUserModule(this._appRouter);
  @override
  void configure() {
    _appRouter.addRoutes(getRoutes());
  }

  @override
  List<RouteBase> getRoutes() {
    return [
      GoRoute(
        path: '/addUser',
        pageBuilder: (context, state) {
          return MaterialPage(
            child: _buildAddUserPage(),
          );
        },
      ),
    ];
  }
  Widget _buildAddUserPage() {
    return BlocProvider<AddUserBloc>(
      create: (context) {
        UsersRepository usersRepository = getIt<UsersRepository>();

        var interactor = AddUserInteractor(usersRepository: usersRepository);
        return AddUserBloc(interactor, userId: '');
      },
      child: AddUserView(),
    );
  }

  @override
  Map<String, WidgetBuilder> getSharedWidgets() {
    return {};
  }
}