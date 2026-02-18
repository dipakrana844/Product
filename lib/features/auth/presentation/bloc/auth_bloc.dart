import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/signup_params.dart';
import '../../domain/usecases/verify_signup_usecase.dart';
import '../../domain/usecases/create_organization_usecase.dart';
import '../../domain/usecases/request_password_reset_usecase.dart';
import '../../domain/usecases/verify_password_reset_usecase.dart';
import '../../domain/usecases/complete_password_reset_usecase.dart';
import '../../domain/usecases/login_with_otp_usecase.dart';
import '../../domain/usecases/verify_login_otp_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/domain/value_objects/phone_number.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithPasswordUseCase loginWithPassword;
  final SignupUseCase signup;
  final VerifySignupUseCase verifySignup;
  final CreateOrganizationUseCase createOrganization;
  final RequestPasswordResetUseCase requestPasswordReset;
  final VerifyPasswordResetUseCase verifyPasswordReset;
  final CompletePasswordResetUseCase completePasswordReset;
  final LoginWithOtpUseCase loginWithOtp;
  final VerifyLoginOtpUseCase verifyLoginOtp;
  final TokenStorage tokenStorage;
  final GetCurrentUserUseCase getCurrentUser;

  AuthBloc({
    required this.loginWithPassword,
    required this.signup,
    required this.verifySignup,
    required this.createOrganization,
    required this.requestPasswordReset,
    required this.verifyPasswordReset,
    required this.completePasswordReset,
    required this.loginWithOtp,
    required this.verifyLoginOtp,
    required this.tokenStorage,
    required this.getCurrentUser,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<VerifySignupRequested>(_onVerifySignupRequested);
    on<OrganizationCreateRequested>(_onOrganizationCreateRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<PasswordResetVerifyRequested>(_onPasswordResetVerifyRequested);
    on<PasswordResetCompleteRequested>(_onPasswordResetCompleteRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<OtpLoginRequested>(_onOtpLoginRequested);
    on<OtpVerifyRequested>(_onOtpVerifyRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final result = await loginWithPassword(
        LoginParams(email: event.email, password: event.password),
      );
      result.fold(
        (failure) {
          if (failure is OnboardingFailure) {
            emit(OrgCreationRequired());
          } else if (failure is VerificationRequiredFailure) {
            emit(VerifyCodeRequired(type: failure.type));
          } else {
            emit(AuthError(failure.message));
          }
        },
        (authResult) {
          if (authResult.user != null) {
            emit(AuthAuthenticated(authResult.user!));
          } else {
            // If user object is missing but we have access_token, we can retry check status
            add(CheckAuthStatus());
          }
        },
      );
    } catch (e) {
      emit(AuthError('An unexpected error occurred. Please try again.'));
    }
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // Validate phone number before proceeding
    final phoneValidation = PhoneNumberValidator.validate(event.phone);
    if (!phoneValidation.isValid) {
      emit(AuthError(phoneValidation.errorMessage ?? 'Invalid phone number'));
      return;
    }

    final result = await signup(
      SignupParams(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        phone: PhoneNumber(event.phone),
        password: event.password,
        confirmPassword: event.confirmPassword,
        location: event.location,
      ),
    );
    result.fold((failure) => emit(AuthError(failure.message)), (authResult) {
      if (!authResult.phoneVerified) {
        emit(const VerifyCodeRequired(type: 'phone'));
      } else if (!authResult.emailVerified) {
        emit(const VerifyCodeRequired(type: 'email'));
      } else {
        emit(OrgCreationRequired());
      }
    });
  }

  Future<void> _onVerifySignupRequested(
    VerifySignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await verifySignup(VerifyParams(event.type, event.code));
    result.fold((failure) => emit(AuthError(failure.message)), (authResult) {
      // Log user in or move to next verification step
      if (authResult.phoneVerified && authResult.emailVerified) {
        // Both verified -> Go to organization creation or Home
        if (authResult.onboardingStatus == 'PENDING') {
          emit(OrgCreationRequired());
        } else {
          // Fetch user and go home
          add(CheckAuthStatus());
        }
      } else if (authResult.phoneVerified && !authResult.emailVerified) {
        // Phone done, now email
        emit(const VerifyCodeRequired(type: 'email'));
      } else {
        // Still needs phone or unknown state
        emit(VerifyCodeRequired(type: event.type));
      }
    });
  }

  Future<void> _onOrganizationCreateRequested(
    OrganizationCreateRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await createOrganization(
      CreateOrganizationParams(organizationData: event.organizationData),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => add(CheckAuthStatus()),
    );
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await requestPasswordReset(
      RequestPasswordResetParams(email: event.email),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(PasswordResetEmailSent(event.email)),
    );
  }

  Future<void> _onPasswordResetVerifyRequested(
    PasswordResetVerifyRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await verifyPasswordReset(
      VerifyPasswordResetParams(email: event.email, code: event.code),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (token) => emit(PasswordResetCodeVerified(event.email, token)),
    );
  }

  Future<void> _onPasswordResetCompleteRequested(
    PasswordResetCompleteRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await completePasswordReset(
      CompletePasswordResetParams(
        email: event.email,
        resetToken: event.resetToken,
        newPassword: event.newPassword,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await tokenStorage.clearAll();
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    if (tokenStorage.isLoggedIn()) {
      emit(AuthLoading());
      final result = await getCurrentUser(NoParams());
      result.fold((failure) {
        if (failure is OnboardingFailure) {
          emit(OrgCreationRequired());
        } else if (failure is VerificationRequiredFailure) {
          emit(VerifyCodeRequired(type: failure.type));
        } else {
          // If it's a transient error (network, server 500), don't log out.
          // Just show error and let the user retry.
          emit(AuthError(failure.message));
        }
      }, (user) => emit(AuthAuthenticated(user)));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onOtpLoginRequested(
    OtpLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginWithOtp(event.phone);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(OtpSent(event.phone)),
    );
  }

  Future<void> _onOtpVerifyRequested(
    OtpVerifyRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await verifyLoginOtp(
      VerifyLoginOtpParams(phone: event.phone, otp: event.otp),
    );
    result.fold((failure) => emit(AuthError(failure.message)), (authResult) {
      if (!authResult.phoneVerified) {
        emit(const VerifyCodeRequired(type: 'phone'));
      } else if (!authResult.emailVerified) {
        emit(const VerifyCodeRequired(type: 'email'));
      } else if (authResult.onboardingStatus == 'PENDING' ||
          authResult.onboardingStatus == 'INCOMPLETE') {
        emit(OrgCreationRequired());
      } else if (authResult.user != null) {
        emit(AuthAuthenticated(authResult.user!));
      } else {
        add(CheckAuthStatus());
      }
    });
  }
}
