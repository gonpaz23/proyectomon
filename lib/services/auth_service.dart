import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Versión mejorada de autenticación con Google
  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Método moderno para web
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        final UserCredential userCredential = 
            await _auth.signInWithPopup(googleProvider);
        return userCredential.user;
      } else {
        // Método tradicional para móvil
        final GoogleSignInAccount? googleSignInAccount = 
            await _googleSignIn.signIn();
        if (googleSignInAccount == null) return null;
        
        final GoogleSignInAuthentication googleAuth = 
            await googleSignInAccount.authentication;
        
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        
        final UserCredential authResult = 
            await _auth.signInWithCredential(credential);
        return authResult.user;
      }
    } catch (error) {
      print("Error en signInWithGoogle: $error");
      return null;
    }
  }

  // Cerrar sesión (mejorado)
  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
    } catch (error) {
      print("Error en signOut: $error");
    }
  }

  // Obtener usuario actual
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Stream de cambios de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}