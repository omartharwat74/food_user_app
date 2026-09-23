import 'package:food_user_app/features/address/domain/entities/address.dart';

class AddressDto {
  final String id;
  final String? name;
  final String? fullAddress;
  final String? buildingNumber;
  final String? floor;
  final String? apartment;
  final double? lat;
  final double? lng;
  final String? type;

  const AddressDto({
    required this.id,
    this.name,
    this.fullAddress,
    this.buildingNumber,
    this.floor,
    this.apartment,
    this.lat,
    this.lng,
    this.type,
  });

  factory AddressDto.fromJson(Map<String, dynamic> json) {
    return AddressDto(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String?,
      fullAddress: json['full_address'] as String?,
      buildingNumber: json['building_number'] as String?,
      floor: json['floor'] as String?,
      apartment: json['apartment'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng:
          (json['long'] as num?)?.toDouble() ??
          (json['lng'] as num?)?.toDouble(),
      type: json['type'] as String?,
    );
  }

  Address toEntity() {
    return Address(
      id: id,
      label: name ?? '',
      fullAddress:
          fullAddress ??
          '${buildingNumber ?? ''} ${floor ?? ''} ${apartment ?? ''}'.trim(),
      lat: lat ?? 0.0,
      lng: lng ?? 0.0,
      city: '',
      neighborhood: '',
      streetNumber: '',
      buildingNumber: buildingNumber ?? '',
      floor: floor ?? '',
      apartment: apartment ?? '',
      addressType: type?.toUpperCase() ?? 'OTHER',
      isDefault: type == 'primary',
    );
  }
}
