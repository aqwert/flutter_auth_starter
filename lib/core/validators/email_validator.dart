String validate(String email) {
  if (email != null && email.length > 100) {
    return 'Email cannot be more than 100 characters';
  }

  if (email == null || !email.contains("@")) {
    return "Not a valid email.";
  }

  return null;
}
