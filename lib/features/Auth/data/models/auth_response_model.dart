import '../../domain/entities/auth_user.dart';

class AuthResponseModel {
  final String accessToken;
  final String tokenType;
  final String userId;
  final String displayName;
  final String? photoUrl;

  const AuthResponseModel({
    required this.accessToken,
    required this.tokenType,
    required this.userId,
    required this.displayName,
    this.photoUrl,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'tokenType': tokenType,
        'userId': userId,
        'displayName': displayName,
        'photoUrl': photoUrl,
      };

  AuthUser toEntity() => AuthUser(
        userId: userId,
        displayName: displayName,
        photoUrl: photoUrl,
        token: accessToken,
      );
}
