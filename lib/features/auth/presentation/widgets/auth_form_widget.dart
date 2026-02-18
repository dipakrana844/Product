import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import 'auth_header.dart';
import '../../../../core/widgets/form_text_field.dart';
import 'buttons.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

/// A reusable authentication form widget that follows clean architecture principles.
/// This widget handles common authentication UI patterns while allowing for
/// customization of specific form elements.
class AuthFormWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<FormFieldConfig> formFields;
  final String buttonText;
  final VoidCallback? onButtonClick;
  final List<Widget>? additionalWidgets;
  final bool isLoading;
  final String? resendText;
  final VoidCallback? onResendTap;
  final String? switchOptionText;
  final String? switchRoute;
  final bool hasFormValidation;
  final String? Function(String?)? validator;

  const AuthFormWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.formFields,
    required this.buttonText,
    this.onButtonClick,
    this.additionalWidgets,
    this.isLoading = false,
    this.resendText,
    this.onResendTap,
    this.switchOptionText,
    this.switchRoute,
    this.hasFormValidation = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(AppRoutes.home);
          } else if (state is OtpSent) {
            context.go(
              '${AppRoutes.otpVerify}?${AppRoutes.phoneParam}=${state.phone}',
            );
          } else if (state is VerifyCodeRequired) {
            // Handle verification type updates if needed
          } else if (state is OrgCreationRequired) {
            context.go(AppRoutes.createOrganization);
          } else if (state is PasswordResetEmailSent) {
            context.go(
              '${AppRoutes.resetPasswordVerify}?${AppRoutes.emailParam}=${state.email}',
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: hasFormValidation
                    ? Form(key: formKey, child: _buildFormContent(formKey))
                    : _buildFormContent(null),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(GlobalKey<FormState>? formKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32),

        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF333333),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
        ),

        const SizedBox(height: 32),

        ...formFields.map(
          (field) => Column(
            children: [
              FormTextField(
                controller: field.controller,
                label: field.label,
                hint: field.hint,
                keyboardType: field.keyboardType,
                borderOnly: field.borderOnly,
                validator: validator ?? field.validator,
                obscureText: field.obscureText,
                suffixIcon: field.suffixIcon,
                prefixIcon: field.prefixIcon,
              ),
              const SizedBox(height: 16), // Space between fields
            ],
          ),
        ),

        if (additionalWidgets != null)
          ...additionalWidgets!.map(
            (widget) => Column(
              children: [
                widget,
                const SizedBox(height: 16), // Space after additional widgets
              ],
            ),
          ),

        Buttons.primary(
          text: buttonText,
          isLoading: isLoading,
          onPressed: onButtonClick != null
              ? () {
                  if (!hasFormValidation ||
                      formKey?.currentState?.validate() == true) {
                    onButtonClick!();
                  }
                }
              : () {},
        ),

        if (resendText != null || switchOptionText != null) ...[
          const SizedBox(height: 24),
          if (resendText != null && onResendTap != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive code? ",
                  style: TextStyle(color: Colors.grey[800]),
                ),
                GestureDetector(
                  onTap: onResendTap,
                  child: const Text(
                    'Resend',
                    style: TextStyle(
                      color: Color(0xFF3F69B8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
          else if (switchOptionText != null && switchRoute != null)
            Builder(
              builder: (context) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      switchOptionText!,
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Use constants for known routes
                        if (switchRoute == AppRoutes.login) {
                          GoRouter.of(context).go(AppRoutes.login);
                        } else if (switchRoute == AppRoutes.signup) {
                          GoRouter.of(context).go(AppRoutes.signup);
                        } else {
                          GoRouter.of(context).go(switchRoute!);
                        }
                      },
                      child: Text(
                        switchRoute == AppRoutes.login
                            ? 'Login with Password'
                            : 'Sign Up',
                        style: const TextStyle(
                          color: Color(0xFF3F69B8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ],
    );
  }
}

/// Configuration class for form fields to customize the AuthFormWidget
class FormFieldConfig {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final bool borderOnly;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  FormFieldConfig({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.borderOnly = false,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
  });
}
