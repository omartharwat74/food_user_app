import 'package:equatable/equatable.dart';
import 'package:food_user_app/features/user/domain/models/update_profile_request.dart';
import 'package:food_user_app/features/user/domain/models/update_settings_request.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileEvent extends ProfileEvent {
  const GetProfileEvent();
}

class ClearProfileEvent extends ProfileEvent {
  const ClearProfileEvent();
}

class UpdateProfileEvent extends ProfileEvent {
  final UpdateProfileRequest request;
  const UpdateProfileEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class GetSettingsEvent extends ProfileEvent {
  const GetSettingsEvent();
}

class UpdateSettingsEvent extends ProfileEvent {
  final UpdateSettingsRequest request;
  const UpdateSettingsEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class DeleteAccountEvent extends ProfileEvent {
  const DeleteAccountEvent();
}

class SendCurrentPhoneOtpEvent extends ProfileEvent {
  const SendCurrentPhoneOtpEvent();
}

class VerifyCurrentPhoneOtpEvent extends ProfileEvent {
  final String otp;
  const VerifyCurrentPhoneOtpEvent(this.otp);
  @override
  List<Object?> get props => [otp];
}

class SendNewPhoneOtpEvent extends ProfileEvent {
  final String phone;
  const SendNewPhoneOtpEvent(this.phone);
  @override
  List<Object?> get props => [phone];
}

class VerifyNewPhoneOtpEvent extends ProfileEvent {
  final String phone;
  final String otp;
  const VerifyNewPhoneOtpEvent({required this.phone, required this.otp});
  @override
  List<Object?> get props => [phone, otp];
}
