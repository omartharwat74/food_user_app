import 'package:food_user_app/features/profile/domain/models/saved_address.dart';

class SavedAddressDto {
  const SavedAddressDto({
    required this.id,
    this.label,
    this.fullAddress,
    this.lat,
    this.lng,
    this.city,
    this.neighborhood,
    this.streetNumber,
    this.buildingNumber,
    this.floor,
    this.apartment,
    this.addressType,
    this.isDefault = false,
  });

  final String id;
  final String? label;
  final String? fullAddress;
  final double? lat;
  final double? lng;
  final String? city;
  final String? neighborhood;
  final String? streetNumber;
  final String? buildingNumber;
  final String? floor;
  final String? apartment;
  final String? addressType;
  final bool isDefault;

  factory SavedAddressDto.fromJson(Map<String, dynamic> json) {
    final type = _readString(json, 'type') ?? 'other';
    return SavedAddressDto(
      id: _readString(json, 'id') ?? '',
      label: _readString(json, 'name'),
      fullAddress: _readString(json, 'full_address'),
      lat: _readDouble(json, 'lat'),
      lng: _readDouble(json, 'long'),
      city: null,
      neighborhood: null,
      streetNumber: null,
      buildingNumber: _readString(json, 'building_number'),
      floor: _readString(json, 'floor'),
      apartment: _readString(json, 'apartment'),
      addressType: type,
      isDefault: type == 'primary',
    );
  }

  SavedAddress toEntity() {
    // Use the user-given label as-is for Arabic (it's typically in Arabic from the backend).
    // For English, fall back to a localized type label so it doesn't show raw Arabic.
    final rawLabel = _nonEmpty(label);
    final titleAr = rawLabel ?? _addressTypeLabelAr(addressType);
    final titleEn = _addressTypeLabelEn(
      addressType,
    ); // always English regardless of label
    final details = _detailsText();
    final location = _locationText();

    return SavedAddress(
      id: id,
      titleAr: titleAr,
      titleEn: titleEn,
      detailsAr: details,
      detailsEn: details,
      locationAr: location,
      locationEn: location,
      latitude: lat ?? 0,
      longitude: lng ?? 0,
      fullAddress: fullAddress,
      city: city,
      neighborhood: neighborhood,
      streetNumber: streetNumber,
      buildingNumber: buildingNumber,
      floor: floor,
      apartment: apartment,
      addressType: addressType,
      isDefault: isDefault,
    );
  }

  String _detailsText() {
    final parts = <String>[
      if (_nonEmpty(buildingNumber) != null) 'Building: ${buildingNumber!}',
      if (_nonEmpty(apartment) != null) 'Apartment: ${apartment!}',
      if (_nonEmpty(floor) != null) 'Floor: ${floor!}',
    ];
    return parts.isEmpty ? _locationText() : parts.join(' / ');
  }

  String _locationText() {
    final full = _nonEmpty(fullAddress);
    if (full != null) return full;
    return [
      city,
      neighborhood,
      streetNumber,
    ].map(_nonEmpty).whereType<String>().join(', ');
  }

  static String _addressTypeLabelAr(String? value) {
    return switch (value?.toLowerCase()) {
      'home' || 'primary' => 'المنزل',
      'work' => 'العمل',
      'apartment' => 'الشقة',
      _ => 'العنوان',
    };
  }

  static String _addressTypeLabelEn(String? value) {
    return switch (value?.toLowerCase()) {
      'home' || 'primary' => 'Home',
      'work' => 'Work',
      'apartment' => 'Apartment',
      _ => 'Address',
    };
  }
}

class SavedAddressRequest {
  const SavedAddressRequest({
    required this.label,
    required this.fullAddress,
    required this.lat,
    required this.lng,
    this.city,
    this.neighborhood,
    this.streetNumber,
    this.buildingNumber,
    this.floor,
    this.apartment,
    this.addressType = 'APARTMENT',
    this.isDefault = false,
  });

  final String label;
  final String fullAddress;
  final double lat;
  final double lng;
  final String? city;
  final String? neighborhood;
  final String? streetNumber;
  final String? buildingNumber;
  final String? floor;
  final String? apartment;
  final String addressType;
  final bool isDefault;

  Map<String, dynamic> toJson() {
    return {
      'name': label,
      'lat': lat,
      'long': lng,
      if (_nonEmpty(fullAddress) != null) 'full_address': fullAddress.trim(),
      if (_nonEmpty(buildingNumber) != null)
        'building_number': buildingNumber!.trim(),
      if (_nonEmpty(floor) != null) 'floor': floor!.trim(),
      if (_nonEmpty(apartment) != null) 'apartment': apartment!.trim(),
      'type': addressType.toLowerCase() == 'primary'
          ? 'primary'
          : addressType.toLowerCase() == 'work'
          ? 'work'
          : 'other',
    };
  }
}

String? _readString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  return _nonEmpty(value.toString());
}

double? _readDouble(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

String? _nonEmpty(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}
