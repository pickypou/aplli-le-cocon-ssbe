import 'package:app_lecocon_ssbe/data/domain/entity/users/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class UsersRepository {
  FirebaseFirestore get firestore;

  Future<Map<String, dynamic>> fetchUserData(String userId);

  Future<void> registerUser(Users userId);

  Future<void> login(String email, String password);

  Future<void> resetPassword(String email);

  Future<void> checkAuthenticationStatus();

  Future<void> logOut();
}

class ConcretedUserRepository extends UsersRepository {
  @override
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    try {
      User? currentUser = auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot snapshot =
            await firestore.collection('Users').doc(currentUser.uid).get();
        return snapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception('No current user found.');
      }
    } catch (error) {
      debugPrint('Error fetching user data: $error');
      rethrow;
    }
  }

  @override
  Future<void> registerUser(Users userId) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: userId.email, password: userId.password);
      await firestore
          .collection('Users')
          .doc(result.user!.uid)
          .set({'email': userId.email});
    } catch (error) {
      debugPrint('Error registering user : $error');
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception(
          "Veuillez fournir une adresse e-mail et un mot de passe valide.");
    }
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return userCredential.user;
    } catch (error) {
      debugPrint("Erreur d'authentification :$error");
      throw Exception("Echec de l'authentification :$error");
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (error) {
      debugPrint("Errur de réinitialisaztion du mot de passe: $error");
      if (error is FirebaseAuthException) {
        throw Exception(
            "Echec de la réinitialisation de mot de passe : $error");
      }
      rethrow;
    }
  }

  @override
  Future<void> checkAuthenticationStatus() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        debugPrint('User is signed in!');
      } else {
        debugPrint('User is currently signed out!');
      }
    } catch (error) {
      debugPrint('Error checking authentication status:$error');
      rethrow;
    }
  }

  @override
  Future<void> logOut() {
    try {
      FirebaseAuth.instance.signOut();
    } catch (error) {
      debugPrint('Une erreur est survenue: $error');
    }
    throw UnimplementedError();
  }
}
