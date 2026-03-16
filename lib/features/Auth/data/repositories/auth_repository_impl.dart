import '../../../../core/services/token_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final TokenService _tokenService;

  AuthRepositoryImpl(this._tokenService);

  @override
  Future<AuthUser> login(String email, String password) async {
    throw UnimplementedError('Firebase authentication not yet configured.');
  }

  @override
  Future<AuthUser> register(
      String email, String password, String displayName) async {
    throw UnimplementedError('Firebase authentication not yet configured.');
  }

  @override
  Future<void> logout() async {
    await _tokenService.clearAll();
  }
}
