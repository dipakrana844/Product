
class AppRoutes {
  // Authentication Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String verifySignup = '/verify-signup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPasswordVerify = '/reset-password-verify';
  static const String newPassword = '/new-password';
  static const String otpLogin = '/otp-login';
  static const String otpVerify = '/otp-verify';

  // Organization Routes
  static const String createOrganization = '/create-org';
  static const String organizationList = '/org';

  // Home Routes
  static const String home = '/home';

  // Route Names (for named navigation)
  static const String loginName = 'login';
  static const String signupName = 'signup';
  static const String verifySignupName = 'verify-signup';
  static const String forgotPasswordName = 'forgot-password';
  static const String resetPasswordVerifyName = 'reset-password-verify';
  static const String newPasswordName = 'new-password';
  static const String otpLoginName = 'otp-login';
  static const String otpVerifyName = 'otp-verify';

  // Organization Route Names
  static const String createOrganizationName = 'create-org';
  static const String organizationListName = 'org-list';

  // Home Route Names
  static const String homeName = 'home';

  // Query Parameter Keys
  static const String typeParam = 'type';
  static const String emailParam = 'email';
  static const String tokenParam = 'token';
  static const String phoneParam = 'phone';

  // Default Values
  static const String defaultType = 'phone';
}
