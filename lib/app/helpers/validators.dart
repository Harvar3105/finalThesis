String? validateName(String? name) {
  if (name == null || name.isEmpty) {
    return 'Please fill this field';
  }
  if (name.contains(" ")){
    return 'Should not contain spaces';
  }
  return null;
}

String? validateNotEmpty(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please fill this field';
  }
  return null;
}

String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'Please enter your email';
  }
  final emailRegex = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  if (!emailRegex.hasMatch(email)) {
    return 'Please enter a valid email';
  }

  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'Please enter your password';
  }
  if (password.length < 5) {
    return 'Password must be at least 5 characters long';
  }
  if (!RegExp(r'[A-Z]').hasMatch(password)) {
    return 'Password must contain at least one uppercase letter';
  }
  if (!RegExp(r'[a-z]').hasMatch(password)) {
    return 'Password must contain at least one lowercase letter';
  }
  return null;
}
