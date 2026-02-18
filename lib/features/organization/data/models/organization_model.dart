import '../../domain/entities/organization.dart';
import '../../../../core/domain/value_objects/phone_number.dart';

class OrganizationModel extends Organization {
  const OrganizationModel({
    required super.id,
    required super.name,
    super.email,
    super.phone,
    super.address,
    super.city,
    super.state,
    super.zipCode,
    super.country,
    super.website,
    super.logo,
    required super.team_size,
    super.description,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    int parseTeamSize(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return OrganizationModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: json['email']?.toString(),
      phone: PhoneNumber.tryCreate((json['phone'] ?? '').toString()),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      zipCode: json['zip_code']?.toString(),
      country: json['country']?.toString(),
      website: json['website']?.toString(),
      logo: json['logo']?.toString(),
      team_size: parseTeamSize(json['employee_team_size'] ?? json['team_size']),
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone?.value,
      'address': address,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'country': country,
      'website': website,
      'logo': logo,
      'team_size': team_size,
      'description': description,
    };
  }
}
