import '../models/ride_model.dart';
import 'api_client.dart';
import 'api_config.dart';

class BookingApiService {
  final ApiClient _client = ApiClient();

  Future<RideModel> createRide(Map<String, dynamic> rideData) async {
    final response = await _client.post(ApiConfig.rides, body: rideData);
    return RideModel.fromJson(response);
  }

  Future<RideModel> getRide(String id) async {
    final response = await _client.get(ApiConfig.rideStatus(id));
    return RideModel.fromJson(response);
  }

  Future<List<RideModel>> getRides() async {
    final response = await _client.get(ApiConfig.rides);
    return (response as List).map((json) => RideModel.fromJson(json)).toList();
  }

  Future<RideModel> updateRideStatus(String id, String status) async {
    final response = await _client.patch(ApiConfig.rideStatus(id), body: {
      'status': status,
    });
    return RideModel.fromJson(response);
  }

  double calculateFare(double distanceKm, dynamic vehicleType) {
    // Local calculation simulation
    double base = 100;
    double perKm = 50;
    if (vehicleType.toString().contains('car')) perKm = 80;
    if (vehicleType.toString().contains('van')) perKm = 120;
    return base + (distanceKm * perKm);
  }
}
