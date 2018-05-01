class AppException implements Exception {
  AppException(this.message, {this.signinSuggested});

  final String message;
  final bool signinSuggested;

  @override
  String toString() {
    return message;
  }
}
