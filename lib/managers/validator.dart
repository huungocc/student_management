class Validator {
  static bool validateEmail(String text) {
    RegExp regex = RegExp("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}");
    return regex.hasMatch(text);
  }

  static bool validatePhone(String text) {
    RegExp regex = RegExp("^[0-9\-\+]{10,11}\$");
    return regex.hasMatch(text);
  }

  static bool validateName(String text) {
    RegExp regex = RegExp("^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*\$");
    return regex.hasMatch(text);
  }

  static bool validatePassword(String text) {
    RegExp regex = RegExp("^.{6,}\$");
    return regex.hasMatch(text);
  }
}
