import 'package:flutter/foundation.dart';
import 'package:task_app/task_app/features/profile/controller/services/user_profile_service.dart';
import 'package:task_app/task_app/features/profile/model/user_model.dart';
import 'package:task_app/task_app/utils/functions/error_handler.dart';

import '../../../../services/data/pref/user_pref.dart';

class UserProfileState extends ChangeNotifier {

  UserProfileState(){
    getProfile();
  }
  final _userProfileServiceProvider = UserProfileService();
  final pref = UserPreferences();


  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> getProfile() async {
    try {
      final id =  await pref.getUserId();
      final user = await _userProfileServiceProvider.getProfile(userId: id);
      _userProfile = user;
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
      _userProfile = null;
    } finally {
      notifyListeners();
    }
  }

  Future<void> editProfile({
    required String uid,
    String? displayName,
    String? email,
    String? photoUrl,
  }) async {
    try {
      await _userProfileServiceProvider.editProfile(
          uid: uid, displayName: displayName, email: email, photoUrl: photoUrl);
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteProfile(String userId) async {
    try {
      await _userProfileServiceProvider.deleteProfile(userId);
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      notifyListeners();
    }
  }
}
