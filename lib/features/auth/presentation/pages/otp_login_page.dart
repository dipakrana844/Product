import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/domain/value_objects/phone_number.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_form_widget.dart';

class OtpLoginPage extends StatefulWidget {
  const OtpLoginPage({super.key});

  @override
  State<OtpLoginPage> createState() => _OtpLoginPageState();
}

class _OtpLoginPageState extends State<OtpLoginPage> {
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AuthFormWidget(
          title: AppStrings.welcomeBack,
          subtitle: AppStrings.loginWithPhoneSubtitle,
          formFields: [
            FormFieldConfig(
              controller: _phoneController,
              label: AppStrings.phoneNumberLabel,
              hint: AppStrings.phoneNumberHint,
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v!.isEmpty) return AppStrings.requiredMessage;
                final result = PhoneNumberValidator.validate(v);
                return result.isValid ? null : result.errorMessage;
              },
            ),
          ],
          buttonText: AppStrings.sendOtpButton,
          isLoading: state is AuthLoading,
          onButtonClick: () {
            context.read<AuthBloc>().add(
              OtpLoginRequested(
                _phoneController.text,
              ),
            );
          },
          switchOptionText: AppStrings.preferPassword,
          switchRoute: AppRoutes.login,
        );
      },
    );
  }
}
