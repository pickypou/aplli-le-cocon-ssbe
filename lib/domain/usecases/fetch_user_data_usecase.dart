import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../data/repository/users_repository.dart';

@injectable
class FetchUserDataUseCase {
  final UsersRepository _usersRepository;
  final String userId;

  FetchUserDataUseCase(this.userId, this._usersRepository);

  Future<Map<String, dynamic>> invoke() async {
    try {
      return await _usersRepository.fetchUserData(userId);
    }catch(error) {
      debugPrint("Erreur lors de la récupération des données utilisateurs: $error");
      rethrow;
    }
  }

  Future<void> checkAuthenticationStatus() async {
    await _usersRepository.checkAuthenticationStatus();
  }
}