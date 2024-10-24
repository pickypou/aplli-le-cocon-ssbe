

import 'package:app_lecocon_ssbe/data/repository/users_repository_impl.dart';
import 'package:app_lecocon_ssbe/ui/ui_module.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/inscription/add_user_bloc.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/inscription/add_user_interactor.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/inscription/view/add_user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/di/di.dart';
import '../../../../data/repository/users_repository.dart';

@singleton
class AddUserModule implements UIModule {
  final AppRouter _appRouter;
  
  AddUserModule(this._appRouter);
  
  @override
  void configure(){
    _appRouter.addRoutes(getRoutes());
  }
  
  @override

  List<RouteBase> getRoutes() {
    return[
        GoRoute(
            path: '/inscription',
        pageBuilder: (context, state) {
              return MaterialPage(
                  child: _buildAddUserPage(),
              );
        }
        )
    ];
  }

  @override
  Map<String, WidgetBuilder> getSharedWidgets() {
    return {};
  }
   
   Widget _buildAddUserPage() {
    return BlocProvider<AddUserBloc>(
        create: (context) {
          UsersRepository usersRepository = getIt<UsersRepositoryImpl>();
          var interactor = UserInteractor(usersRepository: usersRepository);
          return AddUserBloc(interactor, userId: '');
        },
      child:  AddUserView(),
        );
   }
   
  }
  
 
  


  