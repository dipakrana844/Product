import '../models/user_model.dart';
import '../../domain/entities/auth_result.dart';

class AuthResponseModel extends AuthResult {
  const AuthResponseModel({
    required super.accessToken,
    required super.userId,
    required super.step,
    required super.message,
    required super.phoneVerified,
    required super.emailVerified,
    required super.onboardingStatus,
    required super.otp,
    super.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    UserModel? user;
    if (json['user'] != null) {
      final userMap = Map<String, dynamic>.from(json['user']);
      
      userMap['active_organization_id'] ??=
          json['active_organization_id'] ?? json['organization_id'];
      user = UserModel.fromJson(userMap);
    } else if (json['id'] != null || json['email'] != null) {
      
      user = UserModel.fromJson(json);
    }

    return AuthResponseModel(
      accessToken:
          json['access_token'] ?? json['token'] ?? json['accessToken'] ?? '',
      userId: json['user_id'] ?? json['userId'] ?? user?.id ?? '',
      step: json['step'] ?? '',
      message: json['message'] ?? '',
      phoneVerified: json['phone_verified'] ?? false,
      emailVerified: json['email_verified'] ?? false,
      onboardingStatus: json['onboarding_status'] ?? '',
      otp: json['otp'] ?? '',
      user: user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'user_id': userId,
      'step': step,
      'message': message,
      'phone_verified': phoneVerified,
      'email_verified': emailVerified,
      'onboarding_status': onboardingStatus,
      'otp': otp,
    };
  }
}
