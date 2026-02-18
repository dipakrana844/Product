class ApiEndpoints {
  // Base paths
  static const String auth = '/api/auth';
  static const String organization = '/api/organization';
  static const String user = '/api/user';
  static const String profile = '/api/profile';

  // Auth endpoints
  static const String signup = '$auth/signup';
  static const String verifySignup = '$auth/signup/verify';
  static const String createOrganization = '$auth/signup/create-organization';
  static const String loginPassword = '$auth/login/password';
  static const String loginOtp = '$auth/login/otp';
  static const String verifyLoginOtp = '$auth/login/otp/verify';
  static const String getCurrentUser = '$auth/me';
  static const String switchOrganization = '$auth/switch-organization';
  static const String requestPasswordReset = '$auth/password-reset/request';
  static const String verifyPasswordReset = '$auth/password-reset/verify';
  static const String completePasswordReset = '$auth/password-reset/complete';

  // Organization endpoints
  static const String getOrganizations = organization;
  static const String getOrganizationDetails = '$organization/';
  static const String createOrganizationEndpoint = organization;
  static const String updateOrganization = '$organization/';
  static const String deleteOrganization = '$organization/';

  // User/Profile endpoints
  static const String getUserProfile = '$user/profile';
  static const String updateUserProfile = '$user/profile';
  static const String changePassword = '$user/change-password';
  static const String updateProfilePicture = '$user/profile-picture';
}