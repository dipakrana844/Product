import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../features/auth/presentation/widgets/otp_input_widget.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_form_widget.dart';

class VerifySignupPage extends StatefulWidget {
  final String type;
  const VerifySignupPage({super.key, required this.type});

  @override
  State<VerifySignupPage> createState() => _VerifySignupPageState();
}

class _VerifySignupPageState extends State<VerifySignupPage> {
  final _codeController = TextEditingController();
  late String _verificationType;

  @override
  void initState() {
    super.initState();
    _verificationType = widget.type;
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(VerifySignupPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.type != oldWidget.type) {
      setState(() {
        _verificationType = widget.type;
        _codeController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is VerifyCodeRequired) {
          if (state.type != _verificationType) {
            context.go('${AppRoutes.verifySignup}?${AppRoutes.typeParam}=${state.type}');
          }
          setState(() {
            _verificationType = state.type;
            _codeController.clear();
          });
        } else if (state is OrgCreationRequired) {
          context.go(AppRoutes.createOrganization);
        } else if (state is AuthAuthenticated) {
          context.go(AppRoutes.home);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return AuthFormWidget(
            title: _verificationType == 'phone'
                ? AppStrings.verifyPhoneTitle
                : AppStrings.verifyEmailTitle,
            subtitle: AppStrings.verificationSubtitle,
            formFields: const [], // Using custom OTP widget instead
            additionalWidgets: [
              Center(
                child: OtpInputWidget(
                  length: 6,
                  controller: _codeController,
                  onCodeChanged: (_) {},
                ),
              ),
            ],
            buttonText: AppStrings.verifyButton,
            isLoading: state is AuthLoading,
            onButtonClick: () {
              if (_codeController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppStrings.invalidCode)),
                );
                return;
              }
              context.read<AuthBloc>().add(
                VerifySignupRequested(_verificationType, _codeController.text),
              );
            },
          );
        },
      ),
    );
  }
}
