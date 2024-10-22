import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entity/users.dart';

abstract class UsersRepository {
  FirebaseFirestore get firestore;

  Future<Map<String, dynamic>> fetchUserData(String userId);
  Future<void> registerUser(Users user);
  Future<User?> login(String email, String password);
  Future<void> resetPassword(String email);
  Future<bool> checkAuthenticationStatus();
  Future<void> logOut();
}

