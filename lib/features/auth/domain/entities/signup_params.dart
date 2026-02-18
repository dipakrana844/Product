import 'package:equatable/equatable.dart';
import '../../../../core/domain/value_objects/phone_number.dart';

class SignupParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final PhoneNumber phone;
  final String password;
  final String confirmPassword;
  final String location;

  const SignupParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone.value,
      'password': password,
      'confirm_password': confirmPassword,
      'location': location,
    };
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    phone,
    password,
    confirmPassword,
    location,
  ];
}
