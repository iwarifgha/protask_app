import 'package:flutter/foundation.dart';
import 'package:task_app/task_app/features/profile/controller/services/user_profile_service.dart';
import 'package:task_app/task_app/features/profile/model/user_model.dart';
import 'package:task_app/task_app/utils/functions/error_handler.dart';

class UserProfileState extends ChangeNotifier {
  final _userProfileServiceProvider = UserProfileService();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<UserProfile> getProfile({required String userId}) async {
    try {
      final user = await _userProfileServiceProvider.getProfile(userId: userId);
      return user;
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
      return UserProfile(userId: '', displayName: '', email: '', joined: '');
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
