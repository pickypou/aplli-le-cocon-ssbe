import 'package:app_lecocon_ssbe/domain/entity/users.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/add_user_event.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/add_user_interactor.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/add_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUserBloc extends Bloc<AddUserEvent, AddUserState> {
  final AddUserInteractor interactor;
  final String userId;

  AddUserBloc(
      this.interactor,
  { required this.userId,
  }) :  super(SignUpInitialState()) {
    on<AddUserSignUpEvent>((event, emit) async {
      emit(SignUpLoadingState());
      try {
        final user = Users(
          id: event.id,
          email: event.email,
          password: event.password,
          userName: event.userName
        );
        event.navigateToAccount();
        await interactor.registerUser(user);
        emit(SignUpSuccessState(userId: ''));
      }catch(error) {
       emit(SignUpErrorState(error.toString()));
      }
    });
  }

}