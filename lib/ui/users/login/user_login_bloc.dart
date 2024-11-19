
import 'package:app_lecocon_ssbe/ui/users/login/user_login_event.dart';
import 'package:app_lecocon_ssbe/ui/users/login/user_login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_interactor.dart';

class UserLoginBloc extends Bloc<UserLoginEvent, UserLoginState> {
  final LoginInteractor userInteractor;
  final String userId;

  UserLoginBloc(this.userInteractor, {required this.userId})
      : super(UserLoginInitial()) {
    on<FetchUserDataEvent>((event, emit) async {
      try {
        Map<String, dynamic> userData =
            await userInteractor.fetchUserData(userId);
        emit(UserDataLoadedState(userData));
      } catch (e) {
        emit(AuthenticationErrorState());
      }
    });
    on<LoginWithEmailPassword>((event, emit) async {
      emit(UserLoginLoading());
      try {
        await userInteractor.login(event.email, event.password);
        Map<String, dynamic> userData =
            await userInteractor.fetchUserData(userId);
        emit(UserDataLoadedState(userData));
        event.navigateToAccount();
      } catch (error) {
        emit(LoginFailure(error: error.toString()));
      }
    });

    on<LogOutEvent>((event, emit) async {
      try {
        await userInteractor.logOut();
        emit(UserLoginInitial());
      } catch (error) {
        emit(AuthenticationErrorState());
      }
    });
  }
}
