import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:task_app/task_app/features/profile/model/user_model.dart';
import 'package:task_app/task_app/services/api/firebase/firestore/firestore_database_service.dart';
import 'package:task_app/task_app/utils/exceptions/exceptions.dart';

class FirebaseAuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirestoreDatabase();

  //GET CURRENT USER
  User getUser() {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return user;
      }
      throw UserNotFoundException();
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException {
      throw GeneralErrorException(message: 'No user logged in');
    } on FirebaseException catch (e) {
      throw GeneralErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      if (kDebugMode) {
        print('This is th error ${e.toString()}');
      }
      throw GeneralErrorException(message: 'An unexpected error occured');
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
  Future<UserProfile> signIn(
      {required String email, required String password}) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user != null) {
        final user = userCredential.user;
        final userProfile = UserProfile(
            userId: user!.uid,
            displayName: user.displayName ?? '', // no disply name enforced yet
            email: user.email!,
            joined: user.metadata.creationTime!.toIso8601String());
        return userProfile;
      }

      return throw GeneralErrorException(message: 'Could not sign you in..');
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException catch (e) {
      throw FirebaseErrorException(
          message: 'An error occured while signing in..${e.message}');
    } on FirebaseException catch (e) {
      throw FirebaseErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      if (kDebugMode) {
        print('This is th error ${e.toString()}');
      }
      throw GeneralErrorException(message: 'An unexpected error occured');
    }
  }

  //SIGN UP
  Future<UserProfile> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
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
          joined: user.metadata.creationTime!.toIso8601String());

      //Create the user profile in firestore
      await _firestore.createUserProfile(user: userProfile);
      return userProfile;
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException catch (e) {
      throw GeneralErrorException(
          message: 'An error occured while signing you up ${e.message}');
    } on FirebaseException catch (e) {
      throw GeneralErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      if (kDebugMode) {
        print('This is th error ${e.toString()}');
      }
      throw GeneralErrorException(message: 'An unexpected error occured');
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
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException catch (e) {
      throw GeneralErrorException(
          message: 'An error occured while signing you up ${e.message}');
    } on FirebaseException catch (e) {
      throw GeneralErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      if (kDebugMode) {
        print('This is th error ${e.toString()}');
      }
      throw GeneralErrorException(message: 'An unexpected error occured');
    }
  }
}
