import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String userId;
  final String displayName;
  final String? photoUrl;
  final String token;

  const AuthUser({
    required this.userId,
    required this.displayName,
    this.photoUrl,
    required this.token,
  });

  @override
  List<Object?> get props => [userId, displayName, photoUrl, token];
}
