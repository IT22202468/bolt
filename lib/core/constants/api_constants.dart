import 'dart:io';

class ApiConstants {
  static String get baseUrl {
    if (Platform.isAndroid) return 'http://10.0.2.2:8080';
    return 'http://localhost:8080';
  }

  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String googleSignIn = '/api/auth/google';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String verifyOtp = '/api/auth/verify-otp';
}
