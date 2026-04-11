import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';
import 'api_client.dart';
import 'api_config.dart';

class LocationApiService {
  final ApiClient _client = ApiClient();
  WebSocketChannel? _channel;

  Future<void> connectWebSocket(String rideId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final wsUrl = Uri.parse('${ApiConfig.locationWs}?ride_id=$rideId&token=$token');
    _channel = WebSocketChannel.connect(wsUrl);
  }

  Stream<dynamic>? get locationStream {
    return _channel?.stream;
  }

  void disconnectWebSocket() {
    _channel?.sink.close();
    _channel = null;
  }

  Future<void> updateLocation(LocationModel location) async {
    // Send via HTTP mapping
    await _client.post(ApiConfig.locationUpdate, body: {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'heading': location.heading,
    });
  }
}
