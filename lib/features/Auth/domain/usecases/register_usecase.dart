import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository _repository;

  RegisterUsecase(this._repository);

  Future<AuthUser> call(String email, String password, String displayName) {
    return _repository.register(email, password, displayName);
  }
}
