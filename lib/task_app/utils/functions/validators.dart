// Validators
bool emailValidator(String email) {
  final RegExp regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$');
  return regex.hasMatch(email.trim());}

bool passwordValidator(String password) {
  return password.length >= 6;
}