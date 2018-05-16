class AppException implements Exception {
  AppException(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}
