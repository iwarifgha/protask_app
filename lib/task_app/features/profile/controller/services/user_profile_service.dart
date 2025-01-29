import 'package:task_app/task_app/features/profile/model/user_model.dart';
import 'package:task_app/task_app/services/api/firebase/firestore/firestore_database_service.dart';

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
    } catch (e) {
      throw Exception(e);
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
    } catch (e) {
      throw Exception(e);
    }
  }

  //Delete profile
  deleteProfile(String userId) async {
    try {
      await _firestoreProvider.deleteUserProfile(userId);
    } catch (e) {
      throw Exception(e);
    }
  }
}
