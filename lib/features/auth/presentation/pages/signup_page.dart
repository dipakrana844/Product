import 'package:auth_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/form_text_field.dart';
import '../../../../core/widgets/phone_input_field.dart';
import '../../../../core/domain/value_objects/phone_number.dart';
import '../../../../features/auth/presentation/widgets/auth_header.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _placeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isConfirmPasswordVisible = ValueNotifier<bool>(
    false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is VerifyCodeRequired) {
            context.go(
              '${AppRoutes.verifySignup}?${AppRoutes.typeParam}=${state.type}',
            );
          } else if (state is OrgCreationRequired) {
            context.push(AppRoutes.createOrganization);
          } else if (state is AuthAuthenticated) {
            context.go(AppRoutes.home);
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
              // 1. Header with shapes
              const AuthHeader(height: 150),
              // 2. Form Content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.signupTitle,
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Fields based on image order

                      // First Name *
                      FormTextField(
                        controller: _firstNameController,
                        hint: AppStrings.firstNameHint,
                        borderOnly: true,
                        validator: (v) =>
                            v!.isEmpty ? AppStrings.required : null,
                      ),
                      const SizedBox(height: 16),

                      // Last Name *
                      FormTextField(
                        controller: _lastNameController,
                        hint: AppStrings.lastNameHint,
                        borderOnly: true,
                        validator: (v) =>
                            v!.isEmpty ? AppStrings.required : null,
                      ),
                      const SizedBox(height: 16),

                      // Enter Your Place *
                      FormTextField(
                        controller: _placeController,
                        hint: AppStrings.placeHint,
                        borderOnly: true,
                        validator: (v) =>
                            v!.isEmpty ? AppStrings.required : null,
                      ),
                      const SizedBox(height: 16),

                      // Phone Number *
                      PhoneInputField(
                        controller: _phoneController,
                        hint: AppStrings.phoneHint,
                        borderOnly: true,
                        isIcon: false,
                        validator: (v) {
                          if (v!.isEmpty) return AppStrings.required;
                          final result = PhoneNumberValidator.validate(v);
                          return result.isValid ? null : result.errorMessage;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email
                      FormTextField(
                        controller: _emailController,
                        hint: AppStrings.emailHintRequired,
                        keyboardType: TextInputType.emailAddress,
                        borderOnly: true,
                        validator: (v) =>
                            !v!.contains('@') ? AppStrings.invalidEmail : null,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      ValueListenableBuilder<bool>(
                        valueListenable: _isPasswordVisible,
                        builder: (context, isVisible, child) {
                          return FormTextField(
                            controller: _passwordController,
                            hint: AppStrings.passwordHintRequired,
                            obscureText: !isVisible,
                            borderOnly: true,
                            validator: (v) =>
                                v!.isEmpty ? AppStrings.required : null,
                            suffixIcon: IconButton(
                              icon: Icon(
                                isVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                _isPasswordVisible.value =
                                    !_isPasswordVisible.value;
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      ValueListenableBuilder<bool>(
                        valueListenable: _isConfirmPasswordVisible,
                        builder: (context, isVisible, child) {
                          return FormTextField(
                            controller: _confirmPasswordController,
                            hint: AppStrings.confirmPasswordHintRequired,
                            obscureText: !isVisible,
                            borderOnly: true,
                            validator: (v) {
                              if (v != _passwordController.text) {
                                return AppStrings.passwordsDoNotMatch;
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                isVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                _isConfirmPasswordVisible.value =
                                    !_isConfirmPasswordVisible.value;
                              },
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // Sign Up Button -> Dark Blue
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return CustomElevatedButton(
                            text: AppStrings.signupButton,
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthBloc>().add(
                                        SignupRequested(
                                          firstName: _firstNameController.text,
                                          lastName: _lastNameController.text,
                                          email: _emailController.text,
                                          phone: _phoneController.text,
                                          password: _passwordController.text,
                                          confirmPassword:
                                              _confirmPasswordController.text,
                                          location: _placeController.text,
                                        ),
                                      );
                                    }
                                  },
                            isLoading: state is AuthLoading,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.haveAccount,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.go(AppRoutes.login),
                            child: Text(
                              AppStrings.loginButton,
                              style: const TextStyle(
                                color: Color(0xFF3F5E97),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
