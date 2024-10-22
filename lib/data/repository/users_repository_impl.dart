

import 'package:app_lecocon_ssbe/data/repository/users_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entity/users.dart';

@injectable
class UsersRepositoryImpl implements UsersRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UsersRepositoryImpl({FirebaseFirestore? firestore, FirebaseAuth? auth})
  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;


  @override
  FirebaseFirestore get firestore => _firestore;

  FirebaseAuth get auth => _auth;

  @override
  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot snapshot = await _firestore.collection('Users').doc(currentUser.uid).get();
        if (snapshot.exists) {
          return snapshot.data() as Map<String, dynamic>;
        } else {
          throw Exception('Aucune donnée utilisateur trouvée.');
        }
      } else {
        throw Exception('Aucun utilisateur connecté.');
      }
    } catch (error) {
      debugPrint('Erreur lors de la récupération des données utilisateur : $error');
      rethrow;
    }
  }

  @override
  Future<void> registerUser(Users user) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      await _firestore.collection('Users').doc(result.user!.uid).set({
        'email': user.email,
        'userName' : user.userName
        // Ajoutez ici d'autres champs si nécessaire
      });
    } catch (error) {
      debugPrint('Erreur lors de l\'inscription de l\'utilisateur : $error');
      throw Exception('Échec de l\'inscription : $error');
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception("Veuillez fournir une adresse e-mail et un mot de passe valides.");
    }
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return userCredential.user;
    } catch (error) {
      debugPrint("Erreur d'authentification : $error");
      throw Exception("Échec de l'authentification : $error");
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (error) {
      debugPrint("Erreur de réinitialisation du mot de passe : $error");
      throw Exception("Échec de la réinitialisation du mot de passe : $error");
    }
  }

  @override
  Future<bool> checkAuthenticationStatus() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        debugPrint('L\'utilisateur est connecté !');
        return true;
      } else {
        debugPrint('L\'utilisateur n\'est pas connecté.');
        return false;
      }
    } catch (error) {
      debugPrint('Erreur lors de la vérification du statut d\'authentification : $error');
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await auth.signOut();
      debugPrint('Déconnexion réussie.');
    } catch (error) {
      debugPrint('Erreur lors de la déconnexion : $error');
      throw Exception('Échec de la déconnexion : $error');
    }
  }
}