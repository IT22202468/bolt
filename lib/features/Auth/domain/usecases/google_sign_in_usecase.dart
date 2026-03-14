import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class GoogleSignInUsecase {
  final AuthRepository _repository;

  GoogleSignInUsecase(this._repository);

  Future<AuthUser> call(String firebaseIdToken) {
    return _repository.googleSignIn(firebaseIdToken);
  }
}
