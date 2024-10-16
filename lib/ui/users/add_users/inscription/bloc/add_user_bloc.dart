
import 'package:app_lecocon_ssbe/data/domain/entity/users/users.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/inscription/bloc/add_user_event.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/inscription/bloc/add_user_state.dart';
import 'package:app_lecocon_ssbe/ui/users/add_users/inscription/interactor/add_user_interactor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUserBloc extends Bloc<AddUserEvent, AddUserState> {
  final UserInteractor userInteractor;
  final String userId;

  AddUserBloc({
    required this.userInteractor,
    required this.userId,
}) : super(AddUserSignUpLoadingState()) {
    on<AddUserSignUpEvent>((event, emit) async {
      emit(AddUserSignUpLoadingState());
      try {
        final users = Users(
            id: event.id,
            userName: event.userName,
            email: event.email,
            password: event.password
           );
        await userInteractor.registerUser(users);
      //  Navigator.pushReplacement(
         // event.context,
          //MaterialPageRoute(builder: (context) => HomePage()),
      //  );
emit(AddUserSignUpSuccessState(userId: userId));
      }catch(error) {
        emit(AddUserSignUpErrorState(error.toString()));
      }
    });
  }
}