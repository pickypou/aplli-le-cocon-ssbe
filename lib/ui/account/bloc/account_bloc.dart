import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../interactor/account_interactor.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountInteractor accountInteractor;
  final String? userId; // Accepter un userId nullable

  AccountBloc({
    required this.accountInteractor,
    required this.userId,
  }) : super(AccountInitial()) {
    // Écoute des événements LoadUserInfo
    on<LoadUserInfo>((event, emit) async {
      // Vérifier si userId est non nul et non vide
      if (userId != null && userId!.isNotEmpty) {
        emit(AccountLoading());
        try {
          final userData = await accountInteractor.fetchUserData(userId!);
          debugPrint('AccountBloc: Données utilisateur chargées avec succès.');
          emit(AccountLoaded(userData: userData));
        } catch (e) {
          debugPrint('AccountBloc: Erreur - ${e.toString()}');
          emit(AccountError(message: e.toString()));
        }
      } else {
        // Si userId est null ou vide
        debugPrint('AccountBloc: Aucun utilisateur connecté.');
        emit(AccountError(message: 'Aucun utilisateur connecté.'));
      }
    });
  }
}
