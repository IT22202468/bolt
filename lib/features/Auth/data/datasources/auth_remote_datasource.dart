import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_response_model.dart';

class AuthRemoteDatasource {
  final ApiClient _apiClient;

  AuthRemoteDatasource(this._apiClient);

  Future<AuthResponseModel> login(String email, String password) async {
    final response = await _apiClient.post(ApiConstants.login, {
      'email': email,
      'password': password,
    });
    return _handleResponse(response);
  }

  Future<AuthResponseModel> register(
      String email, String password, String displayName) async {
    final response = await _apiClient.post(ApiConstants.register, {
      'email': email,
      'password': password,
      'displayName': displayName,
    });
    return _handleResponse(response);
  }

  Future<AuthResponseModel> googleSignIn(String firebaseIdToken) async {
    final response = await _apiClient.post(ApiConstants.googleSignIn, {
      'firebaseIdToken': firebaseIdToken,
    });
    return _handleResponse(response);
  }

  AuthResponseModel _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    }
    final body = jsonDecode(response.body);
    throw Exception(body['message'] ?? 'Request failed (${response.statusCode})');
  }
}
