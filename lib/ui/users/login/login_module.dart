import 'package:app_lecocon_ssbe/core/di/di.dart';
import 'package:app_lecocon_ssbe/data/repository/users_repository.dart';
import 'package:app_lecocon_ssbe/data/repository/users_repository_impl.dart';
import 'package:app_lecocon_ssbe/ui/ui_module.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/inscription/add_user_interactor.dart';
import 'package:app_lecocon_ssbe/ui/users/login/user_login_bloc.dart';
import 'package:app_lecocon_ssbe/ui/users/login/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@singleton
class LoginModule implements UIModule {
  final AppRouter _appRouter;

  LoginModule(this._appRouter);
  @override
  void configure() {
    _appRouter.addRoutes(getRoutes());
  }

  @override
  List<RouteBase> getRoutes() {
    return [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) {
          return MaterialPage(
            child: _buildLoginPage(),
          );
        },
      ),
    ];
  }

  Widget _buildLoginPage() {
    return BlocProvider<UserLoginBloc>(
      create: (context) {
        UsersRepository usersRepository = getIt<UsersRepositoryImpl>();

        var interactor = UserInteractor(usersRepository: usersRepository);
        return UserLoginBloc(interactor, userId: '');
      },
      child: LoginView(),
    );
  }

  @override
  Map<String, WidgetBuilder> getSharedWidgets() {
    return {};
  }
}
