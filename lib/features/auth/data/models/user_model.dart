import '../../domain/entities/user.dart';
import '../../../../core/domain/value_objects/phone_number.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.phone,
    required super.location,
    super.activeOrganizationId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: PhoneNumber.tryCreate(json['phone'] ?? '') ??
          PhoneNumber('+1234567890'),
      location: json['location'] ?? '',
      activeOrganizationId:
          json['active_organization_id'] ?? json['organization_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone.value,
      'location': location,
      'active_organization_id': activeOrganizationId,
    };
  }
}
