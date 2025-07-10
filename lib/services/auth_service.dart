import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // Import for debugPrint

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream para ouvir as mudanças de estado de autenticação
  Stream<User?> get user => _auth.authStateChanges();

  // Método para criar conta com e-mail e senha
  Future<User?> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Usando debugPrint em vez de print
      debugPrint('Erro ao criar conta: ${e.message}');
      return null;
    }
  }

  // Método para fazer login com e-mail e senha
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Usando debugPrint em vez de print
      debugPrint('Erro ao fazer login: ${e.message}');
      return null;
    }
  }

  // Método para fazer logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
