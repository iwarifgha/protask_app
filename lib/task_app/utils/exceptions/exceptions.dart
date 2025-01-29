class NoInternetException implements Exception {}

class SomethingWentWrongException implements Exception {}

class BadResponseException implements Exception {}

class UnexpectedErrorException implements Exception {
  final String message;

  UnexpectedErrorException({required this.message});
}

class UserNotFoundException implements Exception {} 
