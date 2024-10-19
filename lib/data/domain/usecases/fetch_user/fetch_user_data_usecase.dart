import 'package:app_lecocon_ssbe/data/repository/users_repository/users_repository.dart';
import 'package:flutter/material.dart';

class FetchUserDataUseCase {
  final UsersRepository usersRepository;
  final String userId;

  FetchUserDataUseCase(this.usersRepository, this.userId);

  Future<Map<String, dynamic>> invoke() async {
    try {
      return await usersRepository.fetchUserData(userId);
    }catch(error) {
      debugPrint("Erreur lors de la récupération des données utilisateurs: $error");
      rethrow;
    }
  }

  Future<void> checkAuthenticationStatus() async {
    await usersRepository.checkAuthenticationStatus();
  }
}