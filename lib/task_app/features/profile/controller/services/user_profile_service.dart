import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_app/task_app/features/profile/model/user_model.dart';
import 'package:task_app/task_app/services/api/firebase/firestore/firestore_database_service.dart';
import 'package:task_app/task_app/utils/exceptions/exceptions.dart';

class UserProfileService {
  final _firestoreProvider = FirestoreDatabase();

  //------Create-----//
  //There is no method to create profile here because it is created automatically when a user signs up.
  //See the sign up method in authentication for more clarity.

  //Read profile
  Future<UserProfile> getProfile({required String userId}) async {
    try {
      final user = await _firestoreProvider.getUserProfile(userId: userId);
      return user;
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException {
      throw FirebaseErrorException(message: 'No user logged in');
    } on FirebaseException catch (e) {
      throw FirebaseErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      throw GeneralErrorException(message: 'An unexpected error occured');
    }
  }

  //Edit profile
  editProfile({
    required String uid,
    String? displayName,
    String? email,
    String? photoUrl,
  }) async {
    try {
      await _firestoreProvider.updateUserDetails(
          uid: uid, displayName: displayName, email: email, photoUrl: photoUrl);
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException {
      throw FirebaseErrorException(message: 'No user logged in');
    } on FirebaseException catch (e) {
      throw FirebaseErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      throw GeneralErrorException(message: 'An unexpected error occured');
    }
  }

  //Delete profile
  deleteProfile(String userId) async {
    try {
      await _firestoreProvider.deleteUserProfile(userId);
    }on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException {
      throw FirebaseErrorException(message: 'No user logged in');
    } on FirebaseException catch (e) {
      throw FirebaseErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      throw GeneralErrorException(message: 'An unexpected error occured');
    }
  }
}
