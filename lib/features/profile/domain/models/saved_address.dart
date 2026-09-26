import 'dart:ui';

class SavedAddress {
  const SavedAddress({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.detailsAr,
    required this.detailsEn,
    required this.locationAr,
    required this.locationEn,
    required this.latitude,
    required this.longitude,
    this.fullAddress,
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
  final String titleAr;
  final String titleEn;
  final String detailsAr;
  final String detailsEn;
  final String locationAr;
  final String locationEn;
  final double latitude;
  final double longitude;
  final String? fullAddress;
  final String? city;
  final String? neighborhood;
  final String? streetNumber;
  final String? buildingNumber;
  final String? floor;
  final String? apartment;
  final String? addressType;
  final bool isDefault;

  String get iconAsset {
    final type = addressType?.toLowerCase();
    if (type == 'work') {
      return 'assets/images/icons/address/address_type_work.png';
    }
    if (type == 'other' || type == 'office') {
      return 'assets/images/icons/address/address_type_office.png';
    }
    return 'assets/images/icons/address/address_type_home.png';
  }

  String title(Locale locale) => _localized(locale, ar: titleAr, en: titleEn);

  String details(Locale locale) =>
      _localized(locale, ar: detailsAr, en: detailsEn);

  String location(Locale locale) =>
      _localized(locale, ar: locationAr, en: locationEn);

  String? shortLocation(Locale locale) {
    final c = city?.trim() ?? '';
    final n = neighborhood?.trim() ?? '';

    if (c.isNotEmpty && n.isNotEmpty) {
      return locale.languageCode == 'ar' ? '$c ، $n' : '$c, $n';
    } else if (c.isNotEmpty) {
      return c;
    } else if (n.isNotEmpty) {
      return n;
    }

    final f = fullAddress?.trim() ?? '';
    if (f.isNotEmpty) {
      final parts = f
          .split(RegExp(r'[،,]'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      final filteredParts = parts.where((p) => !p.contains('+')).toList();
      if (filteredParts.isEmpty) return f;
      final shortParts = filteredParts.take(2).toList();
      return locale.languageCode == 'ar'
          ? shortParts.join(' ، ')
          : shortParts.join(', ');
    }

    final t = title(locale).trim();
    if (t.isNotEmpty) {
      return t;
    }

    return null;
  }

  SavedAddress copyWith({
    String? titleAr,
    String? titleEn,
    String? detailsAr,
    String? detailsEn,
    String? locationAr,
    String? locationEn,
    double? latitude,
    double? longitude,
    String? fullAddress,
    String? city,
    String? neighborhood,
    String? streetNumber,
    String? buildingNumber,
    String? floor,
    String? apartment,
    String? addressType,
    bool? isDefault,
  }) {
    return SavedAddress(
      id: id,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      detailsAr: detailsAr ?? this.detailsAr,
      detailsEn: detailsEn ?? this.detailsEn,
      locationAr: locationAr ?? this.locationAr,
      locationEn: locationEn ?? this.locationEn,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      fullAddress: fullAddress ?? this.fullAddress,
      city: city ?? this.city,
      neighborhood: neighborhood ?? this.neighborhood,
      streetNumber: streetNumber ?? this.streetNumber,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      floor: floor ?? this.floor,
      apartment: apartment ?? this.apartment,
      addressType: addressType ?? this.addressType,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  static String _localized(
    Locale locale, {
    required String ar,
    required String en,
  }) {
    return locale.languageCode == 'ar' ? ar : en;
  }
}
