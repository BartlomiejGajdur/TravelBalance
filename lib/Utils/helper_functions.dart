import 'package:email_validator/email_validator.dart';

String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return "This field is required";
  }

  final bool isEmailValid = EmailValidator.validate(email);

  if (!isEmailValid) {
    return "Enter a valid email";
  }

  return null;
}
