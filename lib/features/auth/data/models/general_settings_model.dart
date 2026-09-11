import 'package:json_annotation/json_annotation.dart';

part 'general_settings_model.g.dart';

@JsonSerializable()
class GeneralSettings {
  final String? terms;
  @JsonKey(name: 'privacy_policy')
  final String? privacyPolicy;
  @JsonKey(name: 'about_us')
  final String? aboutUs;

  GeneralSettings({this.terms, this.privacyPolicy, this.aboutUs});

  factory GeneralSettings.fromJson(Map<String, dynamic> json) => _$GeneralSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$GeneralSettingsToJson(this);
}
