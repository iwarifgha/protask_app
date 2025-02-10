import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_app/task_app/features/profile/model/user_model.dart';
import 'package:task_app/task_app/services/api/firebase/firestore/firestore_database_service.dart';
import 'package:task_app/task_app/utils/exceptions/exception_handler.dart';
import 'package:task_app/task_app/utils/exceptions/exceptions.dart';

class FirebaseAuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirestoreDatabase();

  //GET CURRENT USER
  User getUser() {
    return handleExceptionSync(() {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return user;
      }
      throw UserNotFoundException();
    });
  }

  //GET AUTHENTICATION STATUS OF USER
  Future<User?> getAuthState() async {
    return handleExceptionSync(() async {
      final user = await _auth.authStateChanges().first;
      return user;
    });
  }

  //SIGN IN
  Future<UserProfile> signIn(
      {required String email, required String password}) async {
    return handleExceptionSync(() async {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user != null) {
        final user = userCredential.user;
        final userProfile = UserProfile(
            userId: user!.uid,
            displayName: user.displayName ?? '', // no disply name enforced yet
            email: user.email!,
            joined: user.metadata.creationTime!.toIso8601String(),
            isEmailVerified: user.emailVerified);
        return userProfile;
      }
      return throw GeneralErrorException(message: 'Could not sign you in..');
    });
  }

  //SIGN UP
  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    return handleExceptionSync(() async {
      //Create a user in firebase auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        // Update displayName in Firebase Auth profile
        await user.updateDisplayName(displayName);
      }

      final userProfile = UserProfile(
          userId: user!.uid,
          displayName: user.displayName!,
          email: user.email!,
          joined: user.metadata.creationTime!.toIso8601String(),
          isEmailVerified: user.emailVerified);

      //Create the user profile in firestore
      await _firestore.createUserProfile(user: userProfile);
    });
  }

  //VERIFY EMAIL
  Future<void> verifyEmail({required User user}) async {
    return handleExceptionSync(() async {
      await user.sendEmailVerification();
    });
  }

  //FORGOT PASS
  Future<void> forgotPassword({required String email}) async {
    return handleExceptionSync(() async {
      await _auth.sendPasswordResetEmail(email: email);
    });
  }
 

  //SIGN OUT

  Future<bool> signOut() async {
    return handleExceptionSync(() async {
      await _auth.signOut();
      final user = _auth.currentUser;
      if (user == null) {
        print('This user has signed out');
        return true;
      }
      return false;
    });
  }
}
