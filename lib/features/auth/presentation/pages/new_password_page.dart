import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/form_text_field.dart';
import '../../../../features/auth/presentation/widgets/auth_header.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class NewPasswordPage extends StatefulWidget {
  final String email;
  final String token;
  const NewPasswordPage({super.key, required this.email, required this.token});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
          if (state is AuthUnauthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.newPasswordSuccess),
                backgroundColor: Colors.green,
              ),
            );
            context.go(AppRoutes.login);
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
              const AuthHeader(isBack: true),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),

                      Text(
                        AppStrings.newPassword,
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ),

                      const SizedBox(height: 32),

                      ValueListenableBuilder<bool>(
                        valueListenable: _isPasswordVisible,
                        builder: (context, isVisible, child) {
                          return FormTextField(
                            controller: _passwordController,
                            label: AppStrings.newPassword,
                            hint: AppStrings.passwordHintDots,
                            obscureText: !isVisible,
                            borderOnly: false,
                            validator: (v) => v!.length < 6
                                ? AppStrings.passwordMinLengthMessage
                                : null,
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

                      const SizedBox(height: 24),

                      ValueListenableBuilder<bool>(
                        valueListenable: _isConfirmPasswordVisible,
                        builder: (context, isVisible, child) {
                          return FormTextField(
                            controller: _confirmPasswordController,
                            label: AppStrings.confirmPassword,
                            hint: '••••••••',
                            obscureText: !isVisible,
                            borderOnly: false,
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

                      const SizedBox(height: 12),
                      Text(
                        AppStrings.passwordRequirements,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF555555),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return CustomElevatedButton(
                            text: AppStrings.resetPassword,
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthBloc>().add(
                                        PasswordResetCompleteRequested(
                                          widget.email,
                                          widget.token,
                                          _passwordController.text,
                                        ),
                                      );
                                    }
                                  },
                            isLoading: state is AuthLoading,
                          );
                        },
                      ),
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
