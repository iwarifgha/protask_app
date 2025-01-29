import 'package:flutter/cupertino.dart';
import 'package:task_app/task_app/features/authentication/controller/service/auth_service_provider.dart';
import 'package:task_app/task_app/services/data/pref/user_pref.dart';
import 'package:task_app/task_app/features/profile/model/user_model.dart';
import 'package:task_app/task_app/utils/functions/error_handler.dart';

class AuthStateProvider extends ChangeNotifier {
  final _userPreferences = UserPreferences();
  final _authServiceProvider = TaskAppAuthServiceProvider();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasOnboarded = false;
  bool get hasOnboarded => _hasOnboarded;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> initializeAuthProvider() async {
    _hasOnboarded = await _userPreferences.getOnboardState();
    _isSignedIn = await _userPreferences.getSignedInState();
    notifyListeners();
  }

  Future<void> setSignedInStateAsTrue() async {
    final signInState = await _userPreferences.setSignedInStateAsTrue();
    _isSignedIn = signInState;
    notifyListeners();
  }

  Future<void> setSignedInStateAsFalse() async {
    final signInState = await _userPreferences.setSignedInStateAsFalse();
    _isSignedIn = signInState;
    notifyListeners();
  }

  Future<void> setOnboardedState() async {
    final onBoardState = await _userPreferences.setOnboardedState();
    _hasOnboarded = onBoardState;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<UserProfile> getAuthState() async {
    try {
      final user = await _authServiceProvider.getAuthState();
      return UserProfile(
          userId: user.uid,
          displayName: user.displayName!,
          email: user.email!,
          joined: user.metadata.creationTime.toString());
    } catch (e) {
      final errorMessage = handleError(e);
      _errorMessage = errorMessage;
      return UserProfile(
          userId: '',
          displayName: '',
          email: '',
          joined: ''); // return Empty user
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    try {
      await Future.delayed(Duration(milliseconds: 500));
      return await _authServiceProvider.signIn(
          email: email, password: password);
    } catch (e) {
      final errorMessage = handleError(e);
      _errorMessage = errorMessage;
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp({required String email, required String displayName, required String password}) async {
    _setLoading(true);
    try {
      await Future.delayed(Duration(seconds: 5));
      await _authServiceProvider.signUp(email: email, password: password, displayName: displayName);
    } catch (e) {
      final errorMessage = handleError(e);
      _errorMessage = errorMessage;
    } finally {
      _setLoading(false);
    }
  }

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
