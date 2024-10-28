import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../../data/dto/user_dto.dart';

@injectable
class AuthService {
  final FirebaseAuth _auth;

  // Injecte FirebaseAuth via le constructeur
  AuthService(this._auth);

  Future<User?> signIn(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<bool> get isConnected => _auth.authStateChanges().map((user) => user != null);

  Stream<UserDto?> get authUser => _auth.authStateChanges().map((user) => user != null
      ? UserDto(
    id: user.uid,
    userName: user.displayName ?? user.email ?? "",
    email: user.email ?? "",
  )
      : null);
}