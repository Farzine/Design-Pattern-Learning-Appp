class Validators {
  static String? validateEmail(String? val) {
    if (val == null || val.isEmpty) return 'Email is required';
   
    if (!RegExp(r".+@.+\..+").hasMatch(val)) return 'Enter a valid email';
    return null;
  }

  static String? validatePassword(String? val) {
    if (val == null || val.isEmpty) return 'Password is required';
    if (val.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}
