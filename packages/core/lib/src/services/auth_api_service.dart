import '../models/user_model.dart';
import 'api_client.dart';
import 'api_config.dart';

class AuthApiService {
  final ApiClient _client = ApiClient();

  Future<UserModel> login(String email, String password) async {
    final response = await _client.post(ApiConfig.authLogin, body: {
      'email': email,
      'password': password,
    });
    return UserModel.fromJson(response['user']);
  }

  Future<UserModel> register(Map<String, dynamic> userData) async {
    final response = await _client.post(ApiConfig.authRegister, body: userData);
    return UserModel.fromJson(response['user']);
  }

  Future<UserModel> getProfile() async {
    final response = await _client.get(ApiConfig.userProfile);
    return UserModel.fromJson(response);
  }

  Future<bool> verifyOtp(String otp) async {
    // Simulated as backend lacks otp endpoint currently
    await Future.delayed(const Duration(seconds: 1));
    return otp == '1234';
  }

  Future<void> resetPassword(String email) async {
    // Simulated
    await Future.delayed(const Duration(seconds: 1));
  }
}
