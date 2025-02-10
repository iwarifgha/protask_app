import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_app/task_app/features/profile/controller/services/user_profile_service.dart';
import 'package:task_app/task_app/features/profile/model/user_model.dart';
import 'package:task_app/task_app/utils/exceptions/exception_handler.dart';
import 'package:task_app/task_app/utils/exceptions/exceptions.dart';

import '../../../../services/api/firebase/auth/firebase_auth_service.dart';

class TaskAppAuthServiceProvider {
  final firebaseAuthProvider = FirebaseAuthService();
  final userProfileService = UserProfileService();

  // User getCurrentUser() {
  //   try {
  //     final user = firebaseAuthProvider.getUser();
  //     return user;
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  User getCurrentUser() {
    return handleExceptionSync(() {
      return firebaseAuthProvider.getUser();
    });
  }

  Future<User> getAuthState() async {
    return handleExceptionSync(() async {
      final status = await firebaseAuthProvider.getAuthState();
      if (status == null) {
        throw UserNotFoundException();
      }
      return status;
    });
  }

  Future<UserProfile> signIn(
      {required String email, required String password}) async {
    return handleExceptionSync(() async {
      return await firebaseAuthProvider.signIn(
          email: email, password: password);
    });
  }

  Future<void> signUp(
      {required String email,
      required String password,
      required String displayName}) async {
    return handleExceptionSync(() async {
      await firebaseAuthProvider.signUp(
          email: email, password: password, displayName: displayName);
    });
  }

  //VERIFY EMAIL
  Future<void> verifyEmail() async {
    return handleExceptionSync(() async {
      final user = getCurrentUser();
      await firebaseAuthProvider.verifyEmail(user: user);
    });
  }

  //FORGOT PASS
  Future<void> forgotPassword({required String email}) async {
    return handleExceptionSync(() async {
      await firebaseAuthProvider.forgotPassword(email: email);
    });
  }

  // Future<void> confirmPassword(
  //     {required String code, required String newPassword}) async {
  //   try {
  //     await firebaseAuthProvider.confirmPassword(
  //         code: code, newPassword: newPassword);
  //   } catch (e) {
  //     throw Exception();
  //   }
  // }

  Future<bool> signOut() async {
    return handleExceptionSync(() async {
      return await firebaseAuthProvider.signOut();
    });
  }
}
