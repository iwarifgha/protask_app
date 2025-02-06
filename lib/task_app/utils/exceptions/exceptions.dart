class NoInternetException implements Exception {}

class SomethingWentWrongException implements Exception {}

class BadResponseException implements Exception {}

class UnexpectedErrorException implements Exception {
  final String message;

  UnexpectedErrorException({required this.message});
}

class FirebaseErrorException implements Exception {
  final String message;

  FirebaseErrorException({required this.message});
}
class NullElementException implements Exception{}
class UserNotFoundException implements Exception {} 
