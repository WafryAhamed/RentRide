import '../models/notification_model.dart';
import 'api_client.dart';
import 'api_config.dart';

class NotificationApiService {
  final ApiClient _client = ApiClient();

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _client.get(ApiConfig.notifications);
    return (response as List).map((json) => NotificationModel.fromJson(json)).toList();
  }

  Future<void> markAsRead(String id) async {
    await _client.patch('${ApiConfig.notifications}/$id/read');
  }

  Future<void> markAllAsRead() async {
    // Add if backend supports it, otherwise mock
    await _client.patch('${ApiConfig.notifications}/read-all');
  }
}
