import 'package:equatable/equatable.dart';
import 'user.dart';

class AuthResult extends Equatable {
  final String accessToken;
  final String userId;
  final String step;
  final String message;
  final bool phoneVerified;
  final bool emailVerified;
  final String onboardingStatus;
  final String otp;
  final User? user;

  const AuthResult({
    required this.accessToken,
    required this.userId,
    required this.step,
    required this.message,
    required this.phoneVerified,
    required this.emailVerified,
    required this.onboardingStatus,
    required this.otp,
    this.user,
  });

  @override
  List<Object?> get props => [
    accessToken,
    userId,
    step,
    message,
    phoneVerified,
    emailVerified,
    onboardingStatus,
    otp,
    user,
  ];
}
