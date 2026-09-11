// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralSettings _$GeneralSettingsFromJson(Map<String, dynamic> json) =>
    GeneralSettings(
      terms: json['terms'] as String?,
      privacyPolicy: json['privacy_policy'] as String?,
      aboutUs: json['about_us'] as String?,
    );

Map<String, dynamic> _$GeneralSettingsToJson(GeneralSettings instance) =>
    <String, dynamic>{
      'terms': instance.terms,
      'privacy_policy': instance.privacyPolicy,
      'about_us': instance.aboutUs,
    };
