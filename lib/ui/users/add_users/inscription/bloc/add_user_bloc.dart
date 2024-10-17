import 'package:app_lecocon_ssbe/data/domain/entity/users/users.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/inscription/bloc/add_user_event.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/inscription/bloc/add_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../interactor/add_user_interactor.dart';



class AddUserBloc extends Bloc<AddUserEvent, AddUserState> {
  final UserInteractor usersInteractor;
  final String userId;

  AddUserBloc(
      this.usersInteractor, {
        required this.userId,
      }) : super(AddUserSignUpInitialState()) {
    on<AddUserSignUpEvent>((event, emit) async {
      emit(AddUserSignUpLoadingState());
      try {
        final users = Users(
          id: event.id,
          email:  event.email,
          password: event.password, 
          userName: event.userName,
        );
        event.navigateToAccount();
        await usersInteractor.registerUser(users);
        emit(AddUserSignUpSuccessState(userId: ''));
      } catch (error) {
        emit(AddUserSignUpErrorState(error.toString()));
      }
    });
  }
}
