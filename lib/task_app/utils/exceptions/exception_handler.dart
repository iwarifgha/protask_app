// exception_handler.dart

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_app/task_app/utils/exceptions/exceptions.dart';

// //For async functions
// Future<T> handleExceptionsAsync<T>(Future<T> Function() action) {
//   try {
//     return action();
//   } on SocketException {
//     throw NoInternetException();
//   } on HttpException {
//     throw SomethingWentWrongException();
//   } on FormatException {
//     throw BadResponseException();
//   } on FirebaseAuthException {
//     throw FirebaseErrorException(message: 'No user logged in');
//   } on FirebaseException catch (e) {
//     throw FirebaseErrorException(
//         message: 'An unexpected error occurred, see here ${e.toString()}');
//   } catch (e) {
//     throw GeneralErrorException(message: 'An unexpected error occurred here: ${e.toString}');
//   }
// }

// For sync functions
T handleExceptionSync<T>(T Function() action) {
  try {
    return action();
  } on SocketException {
    throw NoInternetException();
  } on HttpException {
    throw SomethingWentWrongException();
  } on FormatException {
    throw BadResponseException();
  } on FirebaseAuthException catch(e) {
    throw FirebaseErrorException(message: 'Error here ${e.toString()}');
  } on FirebaseException catch (e) {
    throw FirebaseErrorException(
        message: 'An unexpected error occurred, see here ${e.toString()}');
  } catch (e) {
    throw GeneralErrorException(message: 'An unexpected error occurred ${e.toString}');
  }
}
