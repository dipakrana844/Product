import 'package:equatable/equatable.dart';
import '../../../../core/domain/value_objects/phone_number.dart';

class Organization extends Equatable {
  final String id;
  final String name;
  final String? email;
  final PhoneNumber? phone;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final String? website;
  final String? logo;
  final int team_size;
  final String? description;

  const Organization({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.website,
    this.logo,
    required this.team_size,
    this.description,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    address,
    city,
    state,
    zipCode,
    country,
    website,
    logo,
    team_size,
    description,
  ];

  Organization copyWith({
    String? id,
    String? name,
    String? email,
    PhoneNumber? phone,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? website,
    String? logo,
    int? team_size,
    String? description,
  }) {
    return Organization(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      website: website ?? this.website,
      logo: logo ?? this.logo,
      team_size: team_size ?? this.team_size,
      description: description ?? this.description,
    );
  }
}
