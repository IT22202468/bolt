import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/services/token_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/google_sign_in_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUsecase _loginUsecase;
  final RegisterUsecase _registerUsecase;
  final GoogleSignInUsecase _googleSignInUsecase;
  final TokenService _tokenService;

  AuthCubit({
    required LoginUsecase loginUsecase,
    required RegisterUsecase registerUsecase,
    required GoogleSignInUsecase googleSignInUsecase,
    required TokenService tokenService,
  })  : _loginUsecase = loginUsecase,
        _registerUsecase = registerUsecase,
        _googleSignInUsecase = googleSignInUsecase,
        _tokenService = tokenService,
        super(const AuthInitial());

  Future<void> checkAuthStatus() async {
    final token = await _tokenService.getToken();
    if (token == null) {
      emit(const AuthUnauthenticated());
      return;
    }
    final userId = await _tokenService.getUserId();
    final displayName = await _tokenService.getDisplayName();
    final photoUrl = await _tokenService.getPhotoUrl();
    if (userId != null && displayName != null) {
      emit(AuthAuthenticated(AuthUser(
        userId: userId,
        displayName: displayName,
        photoUrl: photoUrl,
        token: token,
      )));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    try {
      final user = await _loginUsecase(email, password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  Future<void> register(
      String email, String password, String displayName) async {
    emit(const AuthLoading());
    try {
      final user = await _registerUsecase(email, password, displayName);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  Future<void> googleSignIn() async {
    emit(const AuthLoading());
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        emit(const AuthUnauthenticated());
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseUser = userCredential.user!;
      final firebaseIdToken = await firebaseUser.getIdToken();

      final user = AuthUser(
        userId: firebaseUser.uid,
        displayName: firebaseUser.displayName ?? googleUser.displayName ?? '',
        photoUrl: firebaseUser.photoURL,
        token: firebaseIdToken!,
      );
      await _tokenService.saveAuthData(
        token: user.token,
        userId: user.userId,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
      );
      emit(AuthAuthenticated(user));
    } catch (e, stackTrace) {
      debugPrint('[GoogleSignIn] Error: $e');
      debugPrint('[GoogleSignIn] StackTrace: $stackTrace');
      emit(AuthError(_extractMessage(e)));
    }
  }

  Future<void> logout() async {
    await _tokenService.clearAll();
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    emit(const AuthUnauthenticated());
  }

  String _extractMessage(Object e) {
    final msg = e.toString();
    if (msg.startsWith('Exception: ')) return msg.substring(11);
    return msg;
  }
}
