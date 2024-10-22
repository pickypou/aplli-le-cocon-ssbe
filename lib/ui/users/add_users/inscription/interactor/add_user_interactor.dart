import 'package:app_lecocon_ssbe/data/repository/users_repository.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/entity/users.dart';


class UserInteractor {
  final UsersRepository usersRepository;

  UserInteractor({required this.usersRepository});

  Future<void> registerUser(Users user) async {
    try {
      await usersRepository.registerUser(Users(
        id: (user.id),
        userName: user.userName,
        email: user.email,
        password: user.password
      ));
    }catch(error) {
      debugPrint('erreur lors de l\'enregistrement de user : $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    try{
      final user = await usersRepository.fetchUserData(userId);
      return user;
    }catch (error) {
      debugPrint('Erreur lors d" la récupération des données utilisateur');
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await usersRepository.login(email, password);
    }catch(error) {
      debugPrint('Error de connexion:$error');
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await usersRepository.resetPassword(email);
    }catch(error) {
      debugPrint('$error');
    }
  }

  Future<void> checkAuthenticatorStatus() async {
    try {
      await usersRepository.checkAuthenticationStatus();
    }catch (error) {
      debugPrint('redirection échoué: $error');
    }
  }
  Future<void> logOut() async {
    await usersRepository.logOut();
  }


}