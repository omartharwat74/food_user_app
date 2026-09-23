import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/usecases/usecase.dart';
import 'package:food_user_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:food_user_app/features/profile/domain/usecases/get_cached_profile_usecase.dart';
import 'package:food_user_app/features/profile/domain/usecases/get_cached_settings_usecase.dart';

import 'package:food_user_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:food_user_app/features/profile/domain/usecases/get_settings_usecase.dart';
import 'package:food_user_app/features/profile/domain/usecases/update_settings_usecase.dart';
import 'package:food_user_app/features/profile/domain/usecases/delete_account_usecase.dart';
import 'package:food_user_app/features/profile/domain/usecases/change_phone_usecases.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final GetSettingsUseCase getSettingsUseCase;
  final UpdateSettingsUseCase updateSettingsUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  final SendCurrentPhoneOtpUseCase sendCurrentPhoneOtpUseCase;
  final VerifyCurrentPhoneOtpUseCase verifyCurrentPhoneOtpUseCase;
  final SendNewPhoneOtpUseCase sendNewPhoneOtpUseCase;
  final VerifyNewPhoneOtpUseCase verifyNewPhoneOtpUseCase;

  final GetCachedProfileUseCase getCachedProfileUseCase;
  final GetCachedSettingsUseCase getCachedSettingsUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.getSettingsUseCase,
    required this.updateSettingsUseCase,
    required this.deleteAccountUseCase,
    required this.getCachedProfileUseCase,
    required this.getCachedSettingsUseCase,
    required this.sendCurrentPhoneOtpUseCase,
    required this.verifyCurrentPhoneOtpUseCase,
    required this.sendNewPhoneOtpUseCase,
    required this.verifyNewPhoneOtpUseCase,
  }) : super(const ProfileState()) {
    on<GetProfileEvent>(_onGetProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<GetSettingsEvent>(_onGetSettings);
    on<UpdateSettingsEvent>(_onUpdateSettings);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<SendCurrentPhoneOtpEvent>(_onSendCurrentPhoneOtp);
    on<VerifyCurrentPhoneOtpEvent>(_onVerifyCurrentPhoneOtp);
    on<SendNewPhoneOtpEvent>(_onSendNewPhoneOtp);
    on<VerifyNewPhoneOtpEvent>(_onVerifyNewPhoneOtp);
  }

  Future<void> _onGetProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    // Try to load cached data first
    final cachedResult = await getCachedProfileUseCase(NoParams());
    cachedResult.fold(
      (_) {}, // ignore cache errors
      (cachedProfile) {
        if (cachedProfile != null) {
          emit(state.copyWith(profile: cachedProfile));
        }
      },
    );

    emit(state.copyWith(isLoading: true));
    final result = await getProfileUseCase(NoParams());
    if (isClosed || emit.isDone) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (profile) => emit(state.copyWith(isLoading: false, profile: profile)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await updateProfileUseCase(event.request);
    if (isClosed || emit.isDone) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (profile) => emit(
        state.copyWith(
          isLoading: false,
          profile: profile,
          updateProfileSuccess: true,
        ),
      ),
    );
  }

  Future<void> _onGetSettings(
    GetSettingsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    // Try to load cached settings first
    final cachedResult = await getCachedSettingsUseCase(NoParams());
    cachedResult.fold(
      (_) {}, // ignore cache errors
      (cachedSettings) {
        if (cachedSettings != null) {
          emit(state.copyWith(settings: cachedSettings));
        }
      },
    );

    emit(state.copyWith(isLoading: true));
    final result = await getSettingsUseCase(NoParams());
    if (isClosed || emit.isDone) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (settings) => emit(state.copyWith(isLoading: false, settings: settings)),
    );
  }

  Future<void> _onUpdateSettings(
    UpdateSettingsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await updateSettingsUseCase(event.request);
    if (isClosed || emit.isDone) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (settings) => emit(
        state.copyWith(
          isLoading: false,
          settings: settings,
          updateSettingsSuccess: true,
        ),
      ),
    );
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await deleteAccountUseCase(NoParams());
    if (isClosed || emit.isDone) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isLoading: false, deleteAccountSuccess: true)),
    );
  }

  Future<void> _onSendCurrentPhoneOtp(
    SendCurrentPhoneOtpEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await sendCurrentPhoneOtpUseCase(NoParams());
    if (isClosed || emit.isDone) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) =>
          emit(state.copyWith(isLoading: false, sendCurrentOtpSuccess: true)),
    );
  }

  Future<void> _onVerifyCurrentPhoneOtp(
    VerifyCurrentPhoneOtpEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await verifyCurrentPhoneOtpUseCase(event.otp);
    if (isClosed || emit.isDone) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (token) => emit(
        state.copyWith(
          isLoading: false,
          verifyCurrentOtpSuccess: true,
          phoneChangeToken: token,
        ),
      ),
    );
  }

  Future<void> _onSendNewPhoneOtp(
    SendNewPhoneOtpEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.phoneChangeToken == null) {
      emit(state.copyWith(errorMessage: 'No phone change token available'));
      return;
    }
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await sendNewPhoneOtpUseCase(
      SendNewPhoneOtpParams(token: state.phoneChangeToken!, phone: event.phone),
    );
    if (isClosed || emit.isDone) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isLoading: false, sendNewOtpSuccess: true)),
    );
  }

  Future<void> _onVerifyNewPhoneOtp(
    VerifyNewPhoneOtpEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.phoneChangeToken == null) {
      emit(state.copyWith(errorMessage: 'No phone change token available'));
      return;
    }
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await verifyNewPhoneOtpUseCase(
      VerifyNewPhoneOtpParams(
        token: state.phoneChangeToken!,
        phone: event.phone,
        otp: event.otp,
      ),
    );
    if (isClosed || emit.isDone) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (profile) => emit(
        state.copyWith(
          isLoading: false,
          changePhoneSuccess: true,
          profile: profile,
        ),
      ),
    );
  }
}
