import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../domain/value_objects/phone_number.dart';

class PhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final bool borderOnly;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool showValidationIndicator;
  final bool autoFocus;
  final bool isIcon;
  
  const PhoneInputField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.borderOnly = true,
    this.validator,
    this.onChanged,
    this.showValidationIndicator = true,
    this.autoFocus = false,
    this.isIcon = true,
    
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late final TextEditingController _internalController;
  String? _validationError;
  
  @override
  void initState() {
    super.initState();
    _internalController = widget.controller;
    _internalController.addListener(_onTextChanged);
    _validatePhoneNumber(_internalController.text);
  }
  
  @override
  void dispose() {
    _internalController.removeListener(_onTextChanged);
    super.dispose();
  }
  
  void _onTextChanged() {
    final text = _internalController.text;
    _validatePhoneNumber(text);
    widget.onChanged?.call(text);
  }
  
  void _validatePhoneNumber(String value) {
    final result = PhoneNumberValidator.validate(value);
    setState(() {
      _validationError = result.isValid ? null : result.errorMessage;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null && !widget.borderOnly)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.label!, 
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        Stack(
          children: [
            TextFormField(
              controller: _internalController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              autofocus: widget.autoFocus,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                labelText: widget.borderOnly ? widget.label : null,
                hintText: widget.hint ?? '+1 (555) 123-4567',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: widget.isIcon ? const Icon(
                  Icons.phone,
                  color: Color(0xFF3F69B8),
                ) : null,
                suffixIcon: widget.showValidationIndicator 
                  ? _buildValidationIndicator()
                  : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: Color(0xFFC4C4C4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: Color(0xFFC4C4C4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF3F69B8),
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                errorText: _validationError,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-\+\(\)]')),
                LengthLimitingTextInputFormatter(PhoneNumber.maxLength + 5), // Allow extra for formatting
              ],
              onChanged: (_) {}, // Handled by internal listener
              validator: (value) {
                // Run built-in validation first
                final builtInResult = PhoneNumberValidator.validate(value ?? '');
                if (!builtInResult.isValid) {
                  return builtInResult.errorMessage;
                }
                // Run custom validator if provided
                return widget.validator?.call(value);
              },
              // Focus handling managed by Flutter automatically
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildValidationIndicator() {
    if (_validationError != null) {
      return Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 20,
      );
    }
    
    if (_internalController.text.isNotEmpty) {
      final isValid = PhoneNumberValidator.isValid(_internalController.text);
      return Icon(
        isValid ? Icons.check_circle : Icons.warning_amber,
        color: isValid ? Colors.green : Colors.orange,
        size: 20,
      );
    }
    
    return const SizedBox.shrink();
  }
}

/// Extension methods for phone number formatting
extension PhoneFormatting on String {
  /// Format phone number for display
  String formatForDisplay() {
    final phoneNumber = PhoneNumber.tryCreate(this);
    return phoneNumber?.nationalFormat ?? this;
  }
  
  /// Get phone number in E.164 format
  String toE164() {
    final phoneNumber = PhoneNumber.tryCreate(this);
    return phoneNumber?.e164Format ?? this;
  }
  
  /// Get only digits from phone number
  String get digitsOnly {
    return replaceAll(RegExp(r'[^\d]'), '');
  }
}