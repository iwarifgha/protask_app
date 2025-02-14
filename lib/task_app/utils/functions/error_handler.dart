import 'package:task_app/task_app/utils/exceptions/exceptions.dart';

String handleError(dynamic error) {
  if (error is NoInternetException) {
    return ' You have no Internet connection ';
  } else if (error is SomethingWentWrongException) {
    return ' Something went wrong. Please try again ';
  } else if (error is GeneralErrorException) {
    return error.message;
  } else if (error is FirebaseErrorException) {
    return _handleAuthException(error);
  }
  else if (error is UserNotFoundException) {
    return ' No user found ';
  } else if (error is NullElementException) {
    return ' This is an internal error ';
  }
   else if (error is BadResponseException) {
    return ' Incorrect input. Please check and try again ';
  } else {
     return ' Something bad happened, Please restart the app. ${error.toString()} ';
  }
}

String _handleAuthException(FirebaseErrorException e) {
  switch (e.message) {
    case 'email-already-in-use':
      return "This email is already registered. Try logging in.";
    case 'weak-password':
      return "Your password is too weak. Try a stronger one.";
    case 'invalid-email':
      return "Please enter a valid email.";
    default:
      return "Something bad happened. Please try again.";
  }
}
