import '../models/vehicle_model.dart';
import 'api_client.dart';
import 'api_config.dart';

class VehicleApiService {
  final ApiClient _client = ApiClient();

  Future<List<VehicleModel>> getVehicles() async {
    final response = await _client.get(ApiConfig.vehicles);
    return (response as List).map((json) => VehicleModel.fromJson(json)).toList();
  }

  Future<VehicleModel> getVehicle(String id) async {
    final response = await _client.get(ApiConfig.vehicleDetails(id));
    return VehicleModel.fromJson(response);
  }
}
