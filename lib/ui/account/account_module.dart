import 'package:app_lecocon_ssbe/ui/account/view/account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../core/di/di.dart';
import '../../data/repository/users_repository.dart';
import '../users/login/user_login_bloc.dart';
import '../users/login/view/login_view.dart';
import '../ui_module.dart';
import 'account_bloc.dart';
import 'account_interactor.dart';

@singleton
class AccountModule implements UIModule {
  final AppRouter _appRouter;

  AccountModule(this._appRouter); // S'assurer que l'argument est ici

  @override
  void configure() {
    _appRouter.addRoutes(getRoutes());
  }

  @override
  List<RouteBase> getRoutes() {
    return [
      GoRoute(
        path: '/account',
        pageBuilder: (context, state) {
          return MaterialPage(
            child: _buildAccountPage(),
          );
        },
      ),
    ];
  }

  @override
  Map<String, WidgetBuilder> getSharedWidgets() {
    return {};
  }

  Widget _buildAccountPage() {
    final String? userId = getIt<FirebaseAuth>().currentUser?.uid;

    if (userId != null) {
      return BlocProvider<AccountBloc>(
        create: (context) {
          UsersRepository userRepository = getIt<UsersRepository>();
          var interactor = AccountInteractor(userRepository, userId);
          return AccountBloc(accountInteractor: interactor, userId: userId);
        },
        child: const AccountPage(),
      );
    } else {
      return BlocProvider<UserLoginBloc>(
        create: (_) => getIt<UserLoginBloc>(),
        child: LoginView(),
      );
    }
  }
}