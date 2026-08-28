class AuthValidators {
  static final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static bool isEmail(String value) => emailPattern.hasMatch(value.trim());

  static bool isPassword(String value) => value.length >= 8;

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'required';
    }
    if (!isEmail(value)) {
      return 'email';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'required';
    }
    if (!isPassword(value)) {
      return 'password';
    }
    return null;
  }

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'required';
    }
    return null;
  }
}
