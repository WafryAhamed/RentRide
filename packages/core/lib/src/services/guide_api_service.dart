import '../models/travel_guide_model.dart';
import 'api_client.dart';
import 'api_config.dart';

class GuideApiService {
  final ApiClient _client = ApiClient();

  Future<List<TravelGuideModel>> getAllGuides() async {
    final response = await _client.get(ApiConfig.guides);
    return (response as List).map((json) => TravelGuideModel.fromJson(json)).toList();
  }

  Future<TravelGuideModel> getGuideById(String id) async {
    final response = await _client.get('${ApiConfig.guides}/$id');
    return TravelGuideModel.fromJson(response);
  }

  Future<List<TravelGuideModel>> getNearbyPlaces({double maxDistanceKm = 5}) async {
    final response = await _client.get('${ApiConfig.guides}?max_distance=$maxDistanceKm');
    return (response as List).map((json) => TravelGuideModel.fromJson(json)).toList();
  }
}
