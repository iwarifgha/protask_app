import 'package:task_app/task_app/utils/exceptions/exceptions.dart';

String handleError(dynamic error) {
  if (error is NoInternetException) {
    return ' You have no Internet connection ';
  } else if (error is SomethingWentWrongException) {
    return ' Something went wrong. Please try again ';
  } else if (error is GeneralErrorException) {
    return error.message;
  } else if (error is BadResponseException) {
    return ' Incorrect input. Please check and try again ';
  } else {
    print(error);
    return 'Something bad happened, Please try again. ';
  }
}
