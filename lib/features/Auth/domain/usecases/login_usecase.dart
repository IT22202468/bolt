import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository _repository;

  LoginUsecase(this._repository);

  Future<AuthUser> call(String email, String password) {
    return _repository.login(email, password);
  }
}
