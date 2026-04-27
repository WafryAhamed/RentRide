import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class ApiClient {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        return jsonResponse['data'];
      }
      throw Exception(jsonResponse['error'] ?? 'Unknown API Error');
    } else {
      try {
        final jsonResponse = jsonDecode(response.body);
        throw Exception(
          jsonResponse['error'] ?? 'Error ${response.statusCode}',
        );
      } catch (e) {
        if (e is FormatException) {
          throw Exception('Server error: ${response.statusCode}');
        }
        rethrow;
      }
    }
  }

  Future<dynamic> get(String url) async {
    if (ApiConfig.useMock) {
      return _mockResponse('GET', url, null);
    }
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  Future<dynamic> post(String url, {Map<String, dynamic>? body}) async {
    if (ApiConfig.useMock) {
      return _mockResponse('POST', url, body);
    }
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: await _getHeaders(),
        body: body != null ? jsonEncode(body) : null,
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  Future<dynamic> patch(String url, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: await _getHeaders(),
        body: body != null ? jsonEncode(body) : null,
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('PATCH request failed: $e');
    }
  }

  Future<dynamic> put(String url, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: await _getHeaders(),
        body: body != null ? jsonEncode(body) : null,
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  Future<dynamic> delete(String url) async {
    if (ApiConfig.useMock) {
      return _mockResponse('DELETE', url, null);
    }
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: await _getHeaders(),
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('DELETE request failed: $e');
    }
  }

  // Basic in-memory mock responses for frontend-only demo mode.
  Future<dynamic> _mockResponse(
    String method,
    String url,
    Map<String, dynamic>? body,
  ) async {
    // small artificial delay to simulate network
    await Future.delayed(const Duration(milliseconds: 250));

    // Auth: login
    if (url.contains('/auth/login')) {
      return {
        'access_token': 'demo-access-token',
        'refresh_token': 'demo-refresh-token',
        'token_type': 'Bearer',
        'expires_in': 3600,
        'user': {
          'id': 1,
          'full_name': 'Demo Admin',
          'email': body != null && body['email'] != null
              ? body['email']
              : 'admin@demo.local',
          'phone': '+10000000000',
          'role': 'ADMIN',
          'is_active': true,
        },
      };
    }

    // Auth: register
    if (url.contains('/auth/register')) {
      return {
        'access_token': 'demo-access-token',
        'refresh_token': 'demo-refresh-token',
        'token_type': 'Bearer',
        'expires_in': 3600,
        'user': {
          'id': 2,
          'full_name': body?['full_name'] ?? 'Demo User',
          'email': body?['email'] ?? 'user@demo.local',
          'phone': body?['phone'] ?? '+10000000001',
          'role': body?['role'] ?? 'RIDER',
          'is_active': true,
        },
      };
    }

    // Profile
    if (url.contains('/users/profile')) {
      return {
        'id': 1,
        'full_name': 'Demo Admin',
        'email': 'admin@demo.local',
        'phone': '+10000000000',
        'role': 'ADMIN',
        'is_active': true,
      };
    }

    // Generic fallback: return an empty list for collection endpoints
    if (url.contains('/rides') ||
        url.contains('/vehicles') ||
        url.contains('/payments') ||
        url.contains('/notifications')) {
      return [];
    }

    // Default mock error
    throw Exception('No mock implementation for $method $url');
  }
}
