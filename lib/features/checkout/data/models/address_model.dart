import 'package:food_user_app/features/checkout/domain/entities/address.dart';

class AddressModel extends Address {
  const AddressModel({
    required super.id,
    required super.label,
    required super.fullAddress,
    required super.lat,
    required super.lng,
    required super.city,
    required super.neighborhood,
    required super.streetNumber,
    required super.buildingNumber,
    required super.floor,
    required super.apartment,
    required super.addressType,
    required super.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? json['name'] as String? ?? '',
      fullAddress:
          json['full_address'] as String? ??
          json['fullAddress'] as String? ??
          '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng:
          (json['lng'] as num?)?.toDouble() ??
          (json['long'] as num?)?.toDouble() ??
          0.0,
      city: json['city'] as String? ?? '',
      neighborhood: json['neighborhood'] as String? ?? '',
      streetNumber: json['streetNumber'] as String? ?? '',
      buildingNumber:
          json['building_number'] as String? ??
          json['buildingNumber'] as String? ??
          '',
      floor: json['floor'] as String? ?? '',
      apartment: json['apartment'] as String? ?? '',
      addressType:
          json['type'] as String? ?? json['addressType'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? (json['type'] == 'primary'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': label,
      'label': label,
      'full_address': fullAddress,
      'fullAddress': fullAddress,
      'lat': lat,
      'lng': lng,
      'city': city,
      'neighborhood': neighborhood,
      'streetNumber': streetNumber,
      'buildingNumber': buildingNumber,
      'floor': floor,
      'apartment': apartment,
      'addressType': addressType,
      'isDefault': isDefault,
    };
  }
}
