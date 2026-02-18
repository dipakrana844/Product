import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested(this.email, this.password);
}

class SignupRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final String location;
  const SignupRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.location,
  });
}

class VerifySignupRequested extends AuthEvent {
  final String type;
  final String code;
  const VerifySignupRequested(this.type, this.code);
}

class OrganizationCreateRequested extends AuthEvent {
  final Map<String, dynamic> organizationData;
  const OrganizationCreateRequested(this.organizationData);

  @override
  List<Object> get props => [organizationData];
}

class CheckAuthStatus extends AuthEvent {}

class PasswordResetRequested extends AuthEvent {
  final String email;
  const PasswordResetRequested(this.email);
}

class PasswordResetVerifyRequested extends AuthEvent {
  final String email;
  final String code;
  const PasswordResetVerifyRequested(this.email, this.code);
}

class PasswordResetCompleteRequested extends AuthEvent {
  final String email;
  final String resetToken;
  final String newPassword;
  const PasswordResetCompleteRequested(
    this.email,
    this.resetToken,
    this.newPassword,
  );
}

class LogoutRequested extends AuthEvent {}

class OtpLoginRequested extends AuthEvent {
  final String phone;
  const OtpLoginRequested(this.phone);
}

class OtpVerifyRequested extends AuthEvent {
  final String phone;
  final String otp;
  const OtpVerifyRequested(this.phone, this.otp);
}
