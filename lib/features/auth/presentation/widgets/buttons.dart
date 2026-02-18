import 'package:auth_app/core/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class Buttons {
  static Widget primary({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: CustomElevatedButton(
        onPressed: isLoading ? null : onPressed,
        text: text,
        isLoading: isLoading,
      ),
    );
  }
}
