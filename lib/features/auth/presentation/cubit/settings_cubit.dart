import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_user_app/features/auth/data/models/general_settings_model.dart';
import 'package:food_user_app/features/auth/domain/repositories/auth_repository.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsSuccess extends SettingsState {
  final GeneralSettings settings;

  const SettingsSuccess(this.settings);

  @override
  List<Object?> get props => [settings];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class SettingsCubit extends Cubit<SettingsState> {
  final AuthRepository repository;

  SettingsCubit({required this.repository}) : super(SettingsInitial());

  Future<void> fetchSettings() async {
    emit(SettingsLoading());
    final result = await repository.getGeneralSettings();
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (settings) => emit(SettingsSuccess(settings)),
    );
  }
}
