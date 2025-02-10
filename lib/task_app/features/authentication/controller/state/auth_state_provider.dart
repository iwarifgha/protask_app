import 'package:flutter/cupertino.dart';
import 'package:task_app/task_app/features/authentication/controller/service/auth_service_provider.dart';
import 'package:task_app/task_app/features/profile/model/user_model.dart';
import 'package:task_app/task_app/utils/functions/error_handler.dart';

class AuthStateProvider extends ChangeNotifier {
  final _authServiceProvider = TaskAppAuthServiceProvider();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<UserProfile?> getAuthState() async {
    try {
      final user = await _authServiceProvider.getAuthState();
      return UserProfile(
          userId: user.uid,
          displayName: user.displayName!,
          email: user.email!,
          joined: user.metadata.creationTime.toString(),
          isEmailVerified: user.emailVerified);
    } catch (e) {
      final errorMessage = handleError(e);
      _errorMessage = errorMessage;
      return null; // return Empty user
    }
  }

  Future<UserProfile?> signIn(
      {required String email, required String password}) async {
    clearError();
    _setLoading(true);
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return await _authServiceProvider.signIn(
          email: email, password: password);
    } catch (e) {
      //final errorMessage = handleError(e);
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp(
      {required String email,
      required String displayName,
      required String password}) async {
    clearError();
    _setLoading(true);
    try {
      await Future.delayed(Duration(milliseconds: 500));
      await _authServiceProvider.signUp(
          email: email, password: password, displayName: displayName);
      return true;
    } catch (e) {
      //final errorMessage = handleError(e);
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyEmail({required String email}) async {
    try {
      await _authServiceProvider.verifyEmail();
    } catch (e) {
      final errorMessage = handleError(e);
      _errorMessage = errorMessage;
    } finally {
      _setLoading(false);
    }
  }

  //FORGOT PASS
  Future<void> forgotPassword({required String email}) async {
    try {
      await _authServiceProvider.forgotPassword(email: email);
    } catch (e) {
      final errorMessage = handleError(e);
      _errorMessage = errorMessage;
    } finally {
      _setLoading(false);
    }
  }

  // Future<void> confirmPassword(
  //     {required String code, required String newPassword}) async {
  //   try {
  //     await _authServiceProvider.confirmPassword(
  //         code: code, newPassword: newPassword);
  //   } catch (e) {
  //     throw Exception();
  //   }
  // }

  Future<bool> signOut() async {
    _setLoading(true);
    try {
      return await _authServiceProvider.signOut();
    } catch (e) {
      final errorMessage = handleError(e);
      _errorMessage = errorMessage;
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
