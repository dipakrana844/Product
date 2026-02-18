import 'package:equatable/equatable.dart';

class PhoneNumber extends Equatable {
  final String _value;

  static const int minLength = 10;
  static const int maxLength = 15;
  static const String e164Pattern = r'^\+[1-9]\d{1,14}$';
  static const String generalPattern = r'^[\+]?[1-9][\d\s\-\(\)]{7,14}$';

  const PhoneNumber._(this._value);

  factory PhoneNumber(String value) {
    _validate(value);
    return PhoneNumber._(value.trim());
  }

  static PhoneNumber? tryCreate(String value) {
    try {
      return PhoneNumber(value);
    } on InvalidPhoneNumberException {
      return null;
    }
  }

  String get value => _value;

  String get e164Format {
    String cleaned = _value.replaceAll(RegExp(r'[^\d+]'), '');

    if (cleaned.startsWith('+')) {
      return cleaned;
    }

    if (cleaned.length >= 10) {
      return '+$cleaned';
    }

    return cleaned;
  }

  String get nationalFormat {
    String cleaned = _value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleaned.length > 10) {
      cleaned = cleaned.substring(cleaned.length - 10);
    }

    if (cleaned.length == 10) {
      return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    }

    return cleaned;
  }

  bool get isE164 => RegExp(e164Pattern).hasMatch(_value);

  String get digitsOnly => _value.replaceAll(RegExp(r'[^\d]'), '');

  static void _validate(String value) {
    if (value.isEmpty) {
      throw const InvalidPhoneNumberException('Phone number cannot be empty');
    }

    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < minLength) {
      throw InvalidPhoneNumberException(
        'Phone number must be at least $minLength digits',
      );
    }

    if (digitsOnly.length > maxLength) {
      throw InvalidPhoneNumberException(
        'Phone number cannot exceed $maxLength digits',
      );
    }

    if (!RegExp(generalPattern).hasMatch(value)) {
      throw const InvalidPhoneNumberException('Invalid phone number format');
    }
  }

  @override
  List<Object?> get props => [_value];

  @override
  String toString() => _value;
}

class InvalidPhoneNumberException implements Exception {
  final String message;

  const InvalidPhoneNumberException(this.message);

  @override
  String toString() => 'InvalidPhoneNumberException: $message';
}

class PhoneNumberValidator {
  static PhoneNumberValidationResult validate(String value) {
    try {
      PhoneNumber._validate(value);
      return PhoneNumberValidationResult.isValid();
    } on InvalidPhoneNumberException catch (e) {
      return PhoneNumberValidationResult.isInvalid(e.message);
    }
  }

  static bool isValid(String value) {
    return validate(value).isValid;
  }

  static String? getErrorMessage(String value) {
    final result = validate(value);
    return result.isValid ? null : result.errorMessage;
  }
}

class PhoneNumberValidationResult {
  final bool isValid;
  final String? errorMessage;

  const PhoneNumberValidationResult._(this.isValid, this.errorMessage);

  factory PhoneNumberValidationResult.isValid() {
    return const PhoneNumberValidationResult._(true, null);
  }

  factory PhoneNumberValidationResult.isInvalid(String errorMessage) {
    return PhoneNumberValidationResult._(false, errorMessage);
  }
}
