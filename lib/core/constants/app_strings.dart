
class AppStrings {

  static const String appName = 'Auth App';

  // Common UI strings
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String create = 'Create';
  static const String save = 'Save';
  static const String update = 'Update';
  static const String required = 'Required';
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String or = 'OR';
  static const String phoneNumberHint = 'Phone Number';

  // Login page strings
  static const String loginTitle = 'Login';
  static const String loginSubtitle =
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry.';
  static const String loginButton = 'Login';
  static const String loginSuccess = 'Login Success';
  static const String emailLabel = 'Email';
  static const String emailHint = 'abc@gmail.com';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Admin@123';
  static const String forgotPassword = 'Forgot Password';
  static const String newPassword = 'New Password';
  static const String newPasswordHint = 'Enter new password';
  static const String confirmPassword = 'Confirm Password';
  static const String confirmPasswordHint = 'Confirm your password';
  static const String newPasswordSuccess =
      'Password reset successfully. Please login.';
  static const String invalidEmail = 'Invalid email';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String passwordHintDots = '••••••••';
  static const String passwordMinLengthMessage = 'Password must be at least 6 characters';
  static const String passwordRequirements = '(A-Z, a-z, 0-9),(6-20 Characters),(CAPS),(Number),(Special Character)';
  
  // OTP Verify strings
  static const String confirmCodeTitle = 'Confirm Code';
  static const String codeSentToPhonePrefix = 'Code sent to ';
  static const String loginButtonText = 'Login';
  static const String sendOtpButton = 'Send OTP';
  static const String didntReceiveCode = 'Didn\'t receive code?';
  
  // Splash page strings
  static const String connectionError = 'Connection Error';
  static const String retryButton = 'Retry';
  static const String initializing = 'Initializing...';
  

  static const String newHere = 'New here? ';
  static const String createAccount = 'Create an account';
  static const String loginWithGoogle = 'Login with Google';
  static const String loginWithApple = 'Login with Apple';
  static const String phoneLabel = 'Phone';
  static const String phoneHint = 'Phone Number *';
  static const String phoneRequired = 'Phone number is required';
  static const String getOtp = 'Get OTP';

  // Signup page strings
  static const String signupTitle = 'Let\'s Get You Started !';
  static const String signupButton = 'Sign Up';
  static const String haveAccount = 'have an account? ';
  static const String firstNameHint = 'First Name *';
  static const String lastNameHint = 'Last Name *';
  static const String placeHint = 'Enter Your Place *';
  static const String emailHintRequired = 'Email *';
  static const String passwordHintRequired = 'Password *';
  static const String confirmPasswordHintRequired = 'Confirm Password *';

  // Verification strings
  static const String verifyPhoneTitle = 'Verify your Phone';
  static const String verifyEmailTitle = 'Verify your Email';
  static const String verificationSubtitle =
      'We have sent a code to your registered contact';
  static const String verificationCodeLabel = 'Verification Code';
  static const String verificationCodeHint = '123456';
  static const String verifyButton = 'Verify';
  static const String didntGetCodeText = "Didn't get a code? ";
  static const String didntReceiveCodeTextGeneral = "Didn't receive code?";
  static const String invalidCode = 'Please enter a valid code';

  // Forgot password strings
  static const String forgotPasswordTitle = 'Forgot Password';
  static const String forgotPasswordSubtitle =
      'Enter your email to reset password';
  static const String resetPassword = 'Reset Password';
  static const String resetPasswordSuccess =
      'Password reset link sent to your email';
  
  // OTP Login strings
  static const String welcomeBack = 'Welcome Back';
  static const String loginWithPhoneSubtitle = 'Login easily with your phone number';
  static const String phoneNumberLabel = 'Phone Number';
  // static const String phoneNumberHint = '+1234567890';
  static const String requiredMessage = 'Required';
  static const String preferPassword = 'Prefer password? ';
  
  // Reset Password Verify strings
  static const String verificationCodeTitle = 'Verification Code';
  static const String verificationCodeSent = 'We have sent the verification code to\n';
  static const String clickToResendCode = 'Click to resend code';
  static const String enterValidDigitCode = 'Please enter valid digit code';
}

/// Organization-related strings
class OrganizationStrings {
  // Home page strings
  static const String helloUser = 'Hello, ';
  static const String quickActions = 'Quick Actions';
  static const String manageOrganizations = 'Manage Organizations';
  static const String manageOrganizationsSubtitle =
      'Update or delete organizations';
  static const String changePassword = 'Change Password';
  static const String changePasswordSubtitle =
      'Update your security credentials';
  static const String resetPassword = 'Reset Password';
  static const String resetPasswordSubtitle = 'Request a password reset link';
  static const String logout = 'Logout from Device';
  static const String noOrganization = 'No Organization';
  static const String organizationError = 'Error';
  static const String createOrganization = 'Create Organization';
  static const String organizationName = 'Organization Name';
  static const String teamSize = 'Team Size';
  static const String teamSizeEmployees = ' Employees';

  // Organization list page strings
  static const String myOrganizations = 'My Organizations';
  static const String noOrganizationsFound = 'No organizations found';
  static const String createFirstOrganization =
      'Create Your First Organization';
  static const String editDetails = 'Edit Details';
  static const String deleteOrganization = 'Delete Organization';
  static const String deleteOrganizationConfirm = 'Delete Organization?';
  static const String deleteOrganizationMessage =
      'Are you sure you want to delete ';
  static const String deleteOrganizationWarning =
      '? This action cannot be undone.';

  // Create organization page strings
  static const String createOrganizationTitle = 'Create Organization';
  static const String updateOrganizationTitle = 'Update Organization';
  static const String organizationNameRequired =
      'Organization Name is required';
  static const String organizationCreated =
      'Organization Created Successfully!';
  static const String organizationUpdated =
      'Organization Updated Successfully!';

        // static const String emailHint = 'Email';
  static const String organizationNameHint = 'Organization Name';
  static const String saveAndContinue = 'Save & Continue';
  static const String organizationNameRequiredMessage = 'Organization Name is required';
}

/// Common error messages
class ErrorStrings {
  static const String networkError = 'Network error occurred';
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'An unknown error occurred';
  static const String validationError = 'Please check your input';
  static const String unauthorized = 'Unauthorized access';
  static const String forbidden = 'Access forbidden';
}

/// Success messages
class SuccessStrings {
  static const String operationCompleted = 'Operation completed successfully';
  static const String dataSaved = 'Data saved successfully';
  static const String itemDeleted = 'Item deleted successfully';
}
