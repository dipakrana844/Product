import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> signup(Map<String, dynamic> data);
  Future<AuthResponseModel> verifySignup(String type, String code);
  Future<void> createOrganization(Map<String, dynamic> data);
  Future<Map<String, dynamic>> loginWithPassword(String email, String password);
  Future<void> loginWithOtp(String phone);
  Future<Map<String, dynamic>> verifyLoginOtp(String phone, String otp);
  Future<UserModel> getCurrentUser();
  Future<void> requestPasswordReset(String email);
  Future<String> verifyPasswordReset(String email, String code);
  Future<void> completePasswordReset(
    String email,
    String token,
    String newPassword,
  );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;
  final TokenStorage tokenStorage;

  AuthRemoteDataSourceImpl({required this.client, required this.tokenStorage});

  @override
  Future<AuthResponseModel> signup(Map<String, dynamic> data) async {
    final response = await client.post(ApiEndpoints.signup, data: data);
    final responseData =
        (response['data'] is Map && (response['data'] as Map).isEmpty)
        ? response
        : (response['data'] ?? response);
    return AuthResponseModel.fromJson(responseData);
  }

  @override
  Future<AuthResponseModel> verifySignup(String type, String code) async {
    final response = await client.post(
      ApiEndpoints.verifySignup,
      data: {'type': type, 'code': code},
    );
    final responseData =
        (response['data'] is Map && (response['data'] as Map).isEmpty)
        ? response
        : (response['data'] ?? response);
    return AuthResponseModel.fromJson(responseData);
  }

  @override
  Future<void> createOrganization(Map<String, dynamic> data) async {
    await client.post(ApiEndpoints.createOrganization, data: data);
  }

  @override
  Future<Map<String, dynamic>> loginWithPassword(
    String email,
    String password,
  ) async {
    final response = await client.post(
      ApiEndpoints.loginPassword,
      data: {'email': email.trim(), 'password': password.trim()},
    );

    if (response is Map && response.containsKey('data')) {
      final innerData = response['data'];
      if (innerData is Map<String, dynamic>) {
        return innerData;
      }
    }
    return response;
  }

  @override
  Future<void> loginWithOtp(String phone) async {
    await client.post(ApiEndpoints.loginOtp, data: {'phone': phone.trim()});
  }

  @override
  Future<Map<String, dynamic>> verifyLoginOtp(String phone, String otp) async {
    final response = await client.post(
      ApiEndpoints.verifyLoginOtp,
      data: {'phone': phone.trim(), 'otp': otp.trim()},
    );

    if (response is Map && response.containsKey('data')) {
      final innerData = response['data'];
      if (innerData is Map<String, dynamic>) {
        return innerData;
      }
    }
    return response;
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await client.get(ApiEndpoints.getCurrentUser);

    final data = response['data'] ?? response;

    final userData = data['user'] ?? data;
    final phoneVerified = userData['phone_verified'] ?? false;
    final emailVerified = userData['email_verified'] ?? false;

    if (!phoneVerified) {
      throw const VerificationRequiredException(
        'Phone verification required',
        'phone',
      );
    }

    if (!emailVerified) {
      throw const VerificationRequiredException(
        'Email verification required',
        'email',
      );
    }

    final organizations = data['organizations'] as List?;
    final onboardingStatus = data['onboarding_status']?.toString();

    if ((organizations == null || organizations.isEmpty) ||
        onboardingStatus == 'PENDING') {
      throw const OnboardingRequiredException(
        'Onboarding is not completed',
        'CREATE_ORGANIZATION',
      );
    }

    final userJson = Map<String, dynamic>.from(data['user'] ?? data);

    userJson['active_organization_id'] =
        data['active_organization_id'] ??
        tokenStorage.getOrganizationIdFromToken();

    return UserModel.fromJson(userJson);
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await client.post(
      ApiEndpoints.requestPasswordReset,
      data: {'email': email},
    );
  }

  @override
  Future<String> verifyPasswordReset(String email, String code) async {
    final response = await client.post(
      ApiEndpoints.verifyPasswordReset,
      data: {'email': email, 'code': code},
    );

    return response['reset_token'] ?? response['token'] ?? '';
  }

  @override
  Future<void> completePasswordReset(
    String email,
    String token,
    String newPassword,
  ) async {
    await client.post(
      ApiEndpoints.completePasswordReset,
      data: {
        'email': email,
        'reset_token': token,
        'new_password': newPassword,
        'confirm_password': newPassword,
      },
    );
  }
}
