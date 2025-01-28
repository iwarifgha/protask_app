import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final _auth = FirebaseAuth.instance;

  //GET CURRENT USER
  User getUser() {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return user;
      }
      throw Exception('User not found');
    } catch (e) {
      throw Exception(e);
    }
  }

  //GET AUTHENTICATION STATUS OF USER
  Future<User?> getAuthState() async {
    try {
      final user = await _auth.authStateChanges().first;
      return user;
    } catch (e) {
      throw Exception(e);
    }
  }

  //SIGN IN
  Future<bool> signIn({required String email, required String password}) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

       if (userCredential.user == null) {
        return false;
      }
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  //SIGN UP
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      throw Exception(e);
    }
  }

  //SIGN OUT

  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      final user = _auth.currentUser;
      if (user == null) {
        print('This user has signed out');
        return true;
      }
      return false;
    } catch (e) {
      throw Exception(e);
    }
  }
}
