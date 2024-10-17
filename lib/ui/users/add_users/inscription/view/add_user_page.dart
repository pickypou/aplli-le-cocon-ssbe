import 'package:app_lecocon_ssbe/ui/users/add_users/inscription/bloc/add_user_bloc.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/inscription/interactor/add_user_interactor.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/inscription/view/add_user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AddUserPage extends StatelessWidget {
  final UserInteractor userInteractor;
  const AddUserPage({super.key, required this.userInteractor});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AddUserBloc(
           userInteractor,
             userId: '',
        ),
      child: Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(16.0),
        child: AddUserView(),
        ),
      ),
           );
  }
}
