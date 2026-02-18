import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/form_text_field.dart';
import '../../../../core/widgets/phone_input_field.dart';
import '../../../../core/domain/value_objects/phone_number.dart';
import '../../../../features/auth/presentation/widgets/auth_header.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<int> _currentTabIndex = ValueNotifier<int>(
    0,
  ); 

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _isPasswordVisible.dispose();
    _currentTabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AppStrings.loginSuccess)),
            );
            context.go(AppRoutes.home);
          } else if (state is OrgCreationRequired) {
            context.go(AppRoutes.createOrganization);
          } else if (state is VerifyCodeRequired) {
            context.go('${AppRoutes.verifySignup}?${AppRoutes.typeParam}=${state.type}');
          } else if (state is OtpSent) {
            context.pushNamed(
              AppRoutes.otpVerifyName,
              queryParameters: {AppRoutes.phoneParam: state.phone},
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
              // Header
              const AuthHeader(),

              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.loginTitle,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        AppStrings.loginSubtitle,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              // Tab Switcher
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ValueListenableBuilder<int>(
                  valueListenable: _currentTabIndex,
                  builder: (context, activeTab, child) {
                    return Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _currentTabIndex.value = 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: activeTab == 0
                                        ? const Color(0xFF3F69B8)
                                        : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                AppStrings.emailLabel,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: activeTab == 0
                                      ? const Color(0xFF3F69B8)
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => _currentTabIndex.value = 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: activeTab == 1
                                        ? const Color(0xFF3F69B8)
                                        : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                AppStrings.phoneLabel,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: activeTab == 1
                                      ? const Color(0xFF3F69B8)
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: ValueListenableBuilder<int>(
                    valueListenable: _currentTabIndex,
                    builder: (context, activeTab, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (activeTab == 0) ...[
                            // Email
                            FormTextField(
                              controller: _emailController,
                              label: AppStrings.emailLabel,
                              hint: AppStrings.emailHint,
                              keyboardType: TextInputType.emailAddress,
                              borderOnly: false,
                              validator: (v) => !v!.contains('@')
                                  ? AppStrings.invalidEmail
                                  : null,
                            ),
                            const SizedBox(height: 24),

                            // Password
                            ValueListenableBuilder<bool>(
                              valueListenable: _isPasswordVisible,
                              builder: (context, isVisible, child) {
                                return FormTextField(
                                  controller: _passwordController,
                                  label: AppStrings.passwordLabel,
                                  hint: AppStrings.passwordHint,
                                  obscureText: !isVisible,
                                  borderOnly: false,
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

                            // Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => context.go(AppRoutes.forgotPassword),
                                child: Text(
                                  AppStrings.forgotPassword,
                                  style: const TextStyle(
                                    color: Color(0xFF3F69B8),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            // Phone Number
                            PhoneInputField(
                              controller: _phoneController,
                              label: AppStrings.phoneHint,
                              hint: "+1234567890",
                              borderOnly: false,
                              validator: (v) {
                                if (v!.isEmpty) return AppStrings.phoneRequired;
                                final result = PhoneNumberValidator.validate(v);
                                return result.isValid ? null : result.errorMessage;
                              },
                            ),
                            const SizedBox(height: 16),
                          ],

                          const SizedBox(height: 16),

                          // Login Button
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return CustomElevatedButton(
                                text: activeTab == 0
                                    ? AppStrings.loginButton
                                    : AppStrings.getOtp,
                                onPressed: state is AuthLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          if (activeTab == 0) {
                                            context.read<AuthBloc>().add(
                                              LoginRequested(
                                                _emailController.text.trim(),
                                                _passwordController.text.trim(),
                                              ),
                                            );
                                          } else {
                                            context.read<AuthBloc>().add(
                                              OtpLoginRequested(
                                                _phoneController.text.trim(),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                isLoading: state is AuthLoading,
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          // New here? Create an account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.newHere,
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.go(AppRoutes.signup),
                                child: Text(
                                  AppStrings.createAccount,
                                  style: const TextStyle(
                                    color: Color(0xFF3F69B8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // OR Divider
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(color: Colors.grey),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  AppStrings.or,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                              const Expanded(
                                child: Divider(color: Colors.grey),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Google Login
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppAssets.googleIcon,
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppStrings.loginWithGoogle,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Apple Login
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppAssets.appleIcon,
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppStrings.loginWithApple,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
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
