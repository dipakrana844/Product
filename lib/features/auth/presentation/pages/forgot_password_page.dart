import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_form_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String? email;
  const ForgotPasswordPage({super.key, this.email});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      _emailController.text = widget.email!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AuthFormWidget(
          title: AppStrings.forgotPasswordTitle,
          subtitle: AppStrings.forgotPasswordSubtitle,
          formFields: [
            FormFieldConfig(
              controller: _emailController,
              label: AppStrings.emailLabel,
              hint: AppStrings.emailHint,
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  !v!.contains('@') ? AppStrings.invalidEmail : null,
            ),
          ],
          buttonText: AppStrings.resetPassword,
          isLoading: state is AuthLoading,
          onButtonClick: () {
            context.read<AuthBloc>().add(
              PasswordResetRequested(_emailController.text.trim()),
            );
          },
          switchOptionText: 'Remember your password? ',
          switchRoute: AppRoutes.login,
        );
      },
    );
  }
}
