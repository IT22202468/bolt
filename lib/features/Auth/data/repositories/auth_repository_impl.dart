import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/services/token_service.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;
  final TokenService _tokenService;

  AuthRepositoryImpl(this._datasource, this._tokenService);

  @override
  Future<AuthUser> login(String email, String password) async {
    final model = await _datasource.login(email, password);
    await _tokenService.saveAuthData(
      token: model.accessToken,
      userId: model.userId,
      displayName: model.displayName,
      photoUrl: model.photoUrl,
    );
    return model.toEntity();
  }

  @override
  Future<AuthUser> register(
      String email, String password, String displayName) async {
    final model = await _datasource.register(email, password, displayName);
    await _tokenService.saveAuthData(
      token: model.accessToken,
      userId: model.userId,
      displayName: model.displayName,
      photoUrl: model.photoUrl,
    );
    return model.toEntity();
  }

  @override
  Future<AuthUser> googleSignIn(String firebaseIdToken) async {
    final model = await _datasource.googleSignIn(firebaseIdToken);
    await _tokenService.saveAuthData(
      token: model.accessToken,
      userId: model.userId,
      displayName: model.displayName,
      photoUrl: model.photoUrl,
    );
    return model.toEntity();
  }

  @override
  Future<void> logout() async {
    await _tokenService.clearAll();
    await GoogleSignIn().signOut();
  }
}
