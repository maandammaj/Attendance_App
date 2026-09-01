class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}

class BiometricAuthException implements Exception {
  final String message;
  BiometricAuthException(this.message);

  @override
  String toString() => 'BiometricAuthException: $message';
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}