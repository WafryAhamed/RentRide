import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
        throw Exception(jsonResponse['error'] ?? 'Error ${response.statusCode}');
      } catch (e) {
        if (e is FormatException) {
          throw Exception('Server error: ${response.statusCode}');
        }
        rethrow;
      }
    }
  }

  Future<dynamic> get(String url) async {
    try {
      final response = await http.get(Uri.parse(url), headers: await _getHeaders());
      return _processResponse(response);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  Future<dynamic> post(String url, {Map<String, dynamic>? body}) async {
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
    try {
      final response = await http.delete(Uri.parse(url), headers: await _getHeaders());
      return _processResponse(response);
    } catch (e) {
      throw Exception('DELETE request failed: $e');
    }
  }
}
