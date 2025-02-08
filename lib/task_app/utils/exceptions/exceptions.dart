class NoInternetException implements Exception {}

class SomethingWentWrongException implements Exception {}

class BadResponseException implements Exception {}

class GeneralErrorException implements Exception {
  final String message;

  GeneralErrorException({required this.message});
}

class FirebaseErrorException implements Exception {
  final String message;

  FirebaseErrorException({required this.message});
}

class NullElementException implements Exception {}

class UserNotFoundException implements Exception {}
