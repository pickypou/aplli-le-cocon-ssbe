import 'package:app_lecocon_ssbe/ui/users/add_users/inscription/interactor/add_user_interactor.dart';
import 'package:app_lecocon_ssbe/ui/users/login/view/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/repository/users_repository/users_repository.dart';
import '../../HomePage/home_page.dart';
import '../../account/bloc/account_bloc.dart';
import '../../account/interactor/account_interactor.dart';
import '../../account/view/account_page.dart';
import '../../users/add_users/inscription/bloc/add_user_bloc.dart';
import '../../users/add_users/inscription/view/add_user_view.dart';
import '../../users/login/bloc/user_login_bloc.dart';
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
          path: '/account',
          pageBuilder: (context, state) {
            // Récupération de l'ID utilisateur via Firebase Auth
            final String? userId = FirebaseAuth.instance.currentUser?.uid;

            if (userId != null) {
              // Si un utilisateur est connecté, on affiche la page AccountPage
              return MaterialPage(
                child: BlocProvider<AccountBloc>(
                  create: (context) {
                    UsersRepository userRepository = ConcretedUserRepository();
                    var interactor = AccountInteractor(userRepository, userId);
                    return AccountBloc(accountInteractor: interactor, userId: userId);
                  },
                  child: const AccountPage(),
                ),
              );
            } else {
              // Si aucun utilisateur n'est connecté, on redirige vers la page de login
              return const MaterialPage(
                child: LoginPage(),
              );
            }
          },
          routes: [
            GoRoute(
              path: '/login',
              pageBuilder: (context, state) {
                return MaterialPage(
                  child: BlocProvider<UserLoginBloc>(
                    create: (context) {
                      UsersRepository userRepository = ConcretedUserRepository();
                      final userInteractor = UserInteractor(usersRepository: userRepository); // Change selon ton implémentation
                      final userId = FirebaseAuth.instance.currentUser?.uid ?? ''; // Prends l'ID utilisateur si connecté ou un string vide

                      return UserLoginBloc(userInteractor, userId: userId);
                    },
                    child:  LoginView(),
                  ),
                );
              },
            ),

            GoRoute(
              path: 'inscription',
              pageBuilder: (context, state) {
                // Crée le UserInteractor ici
                UsersRepository userRepository = ConcretedUserRepository();
                var userInteractor = UserInteractor(usersRepository: userRepository);

                // Crée le AddUserBloc sans l'ID de l'utilisateur
                return MaterialPage(
                  child: BlocProvider<AddUserBloc>(
                    create: (context) => AddUserBloc(userInteractor, userId: ''),
                    child:  AddUserView(),
                  ),
                );
              },
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
