import 'package:auth_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../features/auth/presentation/widgets/otp_input_widget.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ResetPasswordVerifyPage extends StatefulWidget {
  final String email;
  const ResetPasswordVerifyPage({super.key, required this.email});

  @override
  State<ResetPasswordVerifyPage> createState() =>
      _ResetPasswordVerifyPageState();
}

class _ResetPasswordVerifyPageState extends State<ResetPasswordVerifyPage> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  String _maskEmail(String email) {
    if (email.isEmpty) return '';
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 3) return email;
    return '${name.substring(0, 3)}***@$domain';
  }

  @override
  Widget build(BuildContext context) {
    final maskedEmail = _maskEmail(widget.email);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is PasswordResetCodeVerified) {
            context.go(
              '${AppRoutes.newPassword}?${AppRoutes.emailParam}=${widget.email}&${AppRoutes.tokenParam}=${state.resetToken}',
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
              // Top Banner Design
              const AuthHeader(),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, 
                  children: [
                    Text(
                      AppStrings.verificationCodeTitle,
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        children: [
                          TextSpan(
                            text: AppStrings.verificationCodeSent,
                          ),
                          TextSpan(
                            text: maskedEmail,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold, 
                              color: const Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // OTP Input Fields
                    OtpInputWidget(
                      length: 6,
                      controller:
                          _codeController, 
                      onCodeChanged: (code) {},
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.didntGetCodeText,
                          style: GoogleFonts.inter(color: Colors.grey[600]),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<AuthBloc>().add(
                              PasswordResetRequested(widget.email),
                            );
                          },
                          child: Text(
                            AppStrings.clickToResendCode,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF3F69B8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomElevatedButton(
                          text: AppStrings.verifyButton,
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  final code = _codeController.text;
                                  if (code.length == 6) {
                                    context.read<AuthBloc>().add(
                                      PasswordResetVerifyRequested(
                                        widget.email,
                                        code,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          AppStrings.enterValidDigitCode,
                                        ),
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
            ],
          ),
        ),
      ),
    );
  }
}
