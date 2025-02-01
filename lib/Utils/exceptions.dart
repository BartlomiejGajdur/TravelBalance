class NoRefreshTokenException implements Exception {
  final String message;
  NoRefreshTokenException(
      [this.message =
          "No refresh token available. Please logout and login again."]);

  @override
  String toString() => "NoRefreshTokenException: $message";
}
