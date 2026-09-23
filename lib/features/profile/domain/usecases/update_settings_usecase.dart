import 'package:dartz/dartz.dart';
import 'package:food_user_app/features/user/domain/entities/user_settings.dart';
import 'package:food_user_app/features/user/domain/models/update_settings_request.dart';
import 'package:food_user_app/features/user/domain/repositories/user_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateSettingsUseCase
    extends UseCase<UserSettings, UpdateSettingsRequest> {
  final UserRepository repository;

  UpdateSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, UserSettings>> call(UpdateSettingsRequest params) {
    return repository.updateSettings(params);
  }
}
