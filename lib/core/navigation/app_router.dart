import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/verify_signup_page.dart';
import '../../features/organization/presentation/pages/create_organization_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_verify_page.dart';
import '../../features/auth/presentation/pages/new_password_page.dart';
import '../../features/organization/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/otp_login_page.dart';
import '../../features/auth/presentation/pages/otp_verify_page.dart';
import '../../features/organization/presentation/pages/organization_list_page.dart';
import '../../features/organization/domain/entities/organization.dart';
import '../../core/storage/token_storage.dart';
import '../constants/app_routes.dart';

class AppRouter {
  final TokenStorage _tokenStorage;

  AppRouter(this._tokenStorage);

  /// Create and configure the GoRouter instance
  GoRouter createRouter() {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      redirect: (context, state) {
        final isLoggedIn = _tokenStorage.isLoggedIn();
        final path = state.uri.path;

        // Protected routes - must be logged in
        final isProtectedRoute =
            path.startsWith('/home') ||
            path.startsWith('/org') ||
            path.startsWith('/create-org');

        // Auth routes - should not be visible if logged in
        final isAuthRoute =
            path == AppRoutes.login ||
            path == AppRoutes.signup ||
            path == AppRoutes.otpLogin;

        if (isProtectedRoute && !isLoggedIn) {
          return AppRoutes.login;
        }

        if (isAuthRoute && isLoggedIn) {
          return AppRoutes.home;
        }

        return null;
      },
      routes: _appRoutes,
    );
  }

  /// Define all application routes
  List<RouteBase> get _appRoutes => [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.loginName,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      name: AppRoutes.signupName,
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: AppRoutes.verifySignup,
      name: AppRoutes.verifySignupName,
      builder: (context, state) {
        final type =
            state.uri.queryParameters[AppRoutes.typeParam] ??
            AppRoutes.defaultType;
        return VerifySignupPage(type: type);
      },
    ),
    GoRoute(
      path: AppRoutes.createOrganization,
      name: AppRoutes.createOrganizationName,
      builder: (context, state) {
        final extra = state.extra;
        Organization? organization;
        if (extra is Organization) {
          organization = extra;
        }
        return CreateOrganizationPage(organization: organization);
      },
    ),
    GoRoute(
      path: AppRoutes.organizationList,
      name: AppRoutes.organizationListName,
      builder: (context, state) => const OrganizationListPage(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: AppRoutes.forgotPasswordName,
      builder: (context, state) {
        final email = state.uri.queryParameters[AppRoutes.emailParam] ?? '';
        return ForgotPasswordPage(email: email);
      },
    ),
    GoRoute(
      path: AppRoutes.resetPasswordVerify,
      name: AppRoutes.resetPasswordVerifyName,
      builder: (context, state) {
        final email = state.uri.queryParameters[AppRoutes.emailParam] ?? '';
        return ResetPasswordVerifyPage(email: email);
      },
    ),
    GoRoute(
      path: AppRoutes.newPassword,
      name: AppRoutes.newPasswordName,
      builder: (context, state) {
        final email = state.uri.queryParameters[AppRoutes.emailParam] ?? '';
        final token = state.uri.queryParameters[AppRoutes.tokenParam] ?? '';
        return NewPasswordPage(email: email, token: token);
      },
    ),
    GoRoute(
      path: AppRoutes.otpLogin,
      name: AppRoutes.otpLoginName,
      builder: (context, state) => const OtpLoginPage(),
    ),
    GoRoute(
      path: AppRoutes.otpVerify,
      name: AppRoutes.otpVerifyName,
      builder: (context, state) {
        final phone = state.uri.queryParameters[AppRoutes.phoneParam] ?? '';
        return OtpVerifyPage(phone: phone);
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.homeName,
      builder: (context, state) => const HomePage(),
    ),
  ];
}
