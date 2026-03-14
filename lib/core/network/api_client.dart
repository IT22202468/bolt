import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../services/token_service.dart';

class ApiClient {
  final TokenService _tokenService;
  final http.Client _httpClient;

  ApiClient({TokenService? tokenService, http.Client? httpClient})
      : _tokenService = tokenService ?? TokenService(),
        _httpClient = httpClient ?? http.Client();

  Future<http.Response> post(String path, Map<String, dynamic> body,
      {bool requiresAuth = false}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (requiresAuth) {
      final token = await _tokenService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return _httpClient.post(
      Uri.parse('${ApiConstants.baseUrl}$path'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> get(String path) async {
    final token = await _tokenService.getToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return _httpClient.get(
      Uri.parse('${ApiConstants.baseUrl}$path'),
      headers: headers,
    );
  }
}
