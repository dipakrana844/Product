import 'package:equatable/equatable.dart';
import '../../../../core/domain/value_objects/phone_number.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final PhoneNumber phone;
  final String location;
  final String? activeOrganizationId;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.location,
    this.activeOrganizationId,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    phone,
    location,
    activeOrganizationId,
  ];
}
