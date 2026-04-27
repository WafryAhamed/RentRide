import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_client.dart';
import 'api_config.dart';

class AuthApiService {
  final ApiClient _client = ApiClient();

  /// Login with email and password.
  /// Saves the access_token to SharedPreferences and returns the user profile.
  Future<UserModel> login(String email, String password) async {
    final response = await _client.post(ApiConfig.authLogin, body: {
      'email': email,
      'password': password,
    });

    // response is the 'data' field from the API (extracted by ApiClient._processResponse)
    final accessToken = response['access_token'] as String?;
    if (accessToken != null && accessToken.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', accessToken);
    }

    final refreshToken = response['refresh_token'] as String?;
    if (refreshToken != null && refreshToken.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('refresh_token', refreshToken);
    }

    return UserModel.fromJson(response['user'] as Map<String, dynamic>);
  }

  /// Register a new user.
  /// Saves the access_token to SharedPreferences and returns the user profile.
  Future<UserModel> register(Map<String, dynamic> userData) async {
    // Ensure the field name matches what the Go backend expects
    final payload = {
      'full_name': userData['full_name'] ?? userData['name'] ?? '',
      'email': userData['email'] ?? '',
      'phone': userData['phone'] ?? '',
      'password': userData['password'] ?? '',
      if (userData['role'] != null) 'role': userData['role'],
    };

    final response = await _client.post(ApiConfig.authRegister, body: payload);

    final accessToken = response['access_token'] as String?;
    if (accessToken != null && accessToken.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', accessToken);
    }

    final refreshToken = response['refresh_token'] as String?;
    if (refreshToken != null && refreshToken.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('refresh_token', refreshToken);
    }

    return UserModel.fromJson(response['user'] as Map<String, dynamic>);
  }

  /// Get the current user's profile (requires valid token in SharedPreferences).
  Future<UserModel> getProfile() async {
    final response = await _client.get(ApiConfig.userProfile);
    return UserModel.fromJson(response as Map<String, dynamic>);
  }

  /// Verify OTP (simulated as backend lacks OTP endpoint currently).
  Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return otp == '1234';
  }

  /// Reset password (simulated).
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  /// Logout — clears stored tokens.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
  }
}
