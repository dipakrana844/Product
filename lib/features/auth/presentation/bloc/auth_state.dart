import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object> get props => [message];
}

class VerifyCodeRequired extends AuthState {
  final String type; 
  const VerifyCodeRequired({required this.type});

  @override
  List<Object> get props => [type];
}

class OrgCreationRequired extends AuthState {
  
}

class PasswordResetEmailSent extends AuthState {
  final String email;
  const PasswordResetEmailSent(this.email);
  @override
  List<Object> get props => [email];
}

class PasswordResetCodeVerified extends AuthState {
  final String email;
  final String resetToken;
  const PasswordResetCodeVerified(this.email, this.resetToken);
  @override
  List<Object> get props => [email, resetToken];
}

class OtpSent extends AuthState {
  final String phone;
  const OtpSent(this.phone);
  @override
  List<Object> get props => [phone];
}
