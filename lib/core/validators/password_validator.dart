String validate(String password) {
  if (password != null && password.length > 50) {
    return 'Password cannot be more than 50 characters';
  }

  if (password == null || password.length < 6) {
    return 'Password has to be more than 5 characters';
  }
  return null;
}
