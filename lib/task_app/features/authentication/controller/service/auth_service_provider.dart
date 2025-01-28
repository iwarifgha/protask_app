import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_app/task_app/features/profile/controller/services/user_profile_service.dart';

import '../../../../services/api/firebase/firebase_auth_service.dart';

class TaskAppAuthServiceProvider {
  final firebaseAuthProvider = FirebaseAuthService();
  final userProfileService = UserProfileService();

  User getCurrentUser() {
    try {
      final user = firebaseAuthProvider.getUser();
      return user;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<User?> getAuthState() async {
    try {
      final status = await firebaseAuthProvider.getAuthState();
      return status;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      return await firebaseAuthProvider.signIn(email: email, password: password);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await firebaseAuthProvider.signUp(email: email, password: password);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> signOut() async {
    try {
      return await firebaseAuthProvider.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}
