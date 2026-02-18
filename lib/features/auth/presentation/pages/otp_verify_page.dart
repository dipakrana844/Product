import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_form_widget.dart';
import '../widgets/otp_input_widget.dart';

class OtpVerifyPage extends StatefulWidget {
  final String phone;
  const OtpVerifyPage({super.key, required this.phone});

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AuthFormWidget(
          title: AppStrings.confirmCodeTitle,
          subtitle: '\${AppStrings.codeSentToPhonePrefix}\${widget.phone}',
          formFields: const [], // Using OtpInputWidget
          additionalWidgets: [
            Center(
              child: OtpInputWidget(
                length: 6,
                controller: _otpController,
                onCodeChanged: (_) {},
              ),
            ),
          ],
          buttonText: AppStrings.loginButtonText,
          isLoading: state is AuthLoading,
          onButtonClick: () {
            if (_otpController.text.length < 6) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppStrings.enterValidDigitCode)),
              );
              return;
            }
            context.read<AuthBloc>().add(
              OtpVerifyRequested(widget.phone, _otpController.text),
            );
          },
          resendText: AppStrings.didntReceiveCode,
          onResendTap: () {
            context.read<AuthBloc>().add(OtpLoginRequested(widget.phone));
          },
        );
      },
    );
  }
}
