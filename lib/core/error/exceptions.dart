class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

class OnboardingRequiredException implements Exception {
  final String message;
  final String step;
  const OnboardingRequiredException(this.message, this.step);
}

class VerificationRequiredException implements Exception {
  final String message;
  final String type; // 'phone' or 'email'
  const VerificationRequiredException(this.message, this.type);
}
