import 'package:app_lecocon_ssbe/data/repository/users_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchUserDataUseCase {
  final UsersRepositoryImpl _usersRepositoryImpl;
  final String userId;

  FetchUserDataUseCase(this.userId, this._usersRepositoryImpl);

  Future<Map<String, dynamic>> invoke() async {
    try {
      return await _usersRepositoryImpl.fetchUserData(userId);
    }catch(error) {
      debugPrint("Erreur lors de la récupération des données utilisateurs: $error");
      rethrow;
    }
  }

  Future<void> checkAuthenticationStatus() async {
    await _usersRepositoryImpl.checkAuthenticationStatus();
  }
}