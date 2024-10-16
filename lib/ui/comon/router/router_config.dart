import 'package:app_lecocon_ssbe/ui/users/add_users/inscription/interactor/add_user_interactor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/repository/users_repository/users_repository.dart';
import '../../HomePage/home_page.dart';
import '../../account/bloc/account_bloc.dart';
import '../../account/interactor/account_interactor.dart';
import '../../account/view/account_page.dart';
import '../../users/add_users/inscription/view/add_user_view.dart';
import '../../users/add_users/inscription/bloc/add_user_bloc.dart'; // Make sure to import this
import '../../users/login/view/login_view.dart';
import '../../users/login/view/reset_password_view.dart';

final goRouter = GoRouter(
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'account',
          pageBuilder: (context, state) => MaterialPage(
            child: BlocProvider<AccountBloc>(
              create: (BuildContext context) {
                UsersRepository userRepository = ConcretedUserRepository();
                var userId = state.extra as String? ?? '';
                var interactor = AccountInteractor(userRepository, userId);

                return AccountBloc(
                  accountInteractor: interactor,
                  userId: userId,
                );
              },
              child: const AccountPage(),
            ),
          ),
          routes: [
            GoRoute(
              path: 'login',
              builder: (context, state) => const LoginView(),
            ),
            GoRoute(
              path: 'inscription',
              pageBuilder: (context, state) => MaterialPage(
                child: BlocProvider<AddUserBloc>(
                  create: (BuildContext context) {
                    UsersRepository usersRepository = ConcretedUserRepository();
                    var userId = '';
                    var interactor =
                        UserInteractor(usersRepository: usersRepository);
                    return AddUserBloc(
                        userInteractor: interactor, userId: userId);
                  },
                  child: AddUserView(),
                ),
              ),
            ),
            GoRoute(
              path: 'resetPassword',
              builder: (context, state) => const ResetPasswordView(),
            ),
          ],
        ),
      ],
    ),
  ],
);
