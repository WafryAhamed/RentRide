import '../models/vehicle_model.dart';

/// Mock vehicle service with realistic vehicle listings.
class MockVehicleService {
  static final List<VehicleModel> _vehicles = const [
    // Bikes
    VehicleModel(id: 'v_b1', driverId: 'd_b1', type: VehicleType.bike, make: 'Honda', model: 'PCX 160', year: 2023, plateNumber: 'BIK-5678', color: 'Black', capacity: 1, pricePerKm: 35.0, baseFare: 100.0),
    VehicleModel(id: 'v_b2', driverId: 'd_b2', type: VehicleType.bike, make: 'Yamaha', model: 'NMAX', year: 2023, plateNumber: 'BIK-9012', color: 'Blue', capacity: 1, pricePerKm: 30.0, baseFare: 90.0),
    // Cars
    VehicleModel(id: 'v_c1', driverId: 'd_c1', type: VehicleType.car, make: 'Toyota', model: 'Prius', year: 2022, plateNumber: 'CAB-1234', color: 'White', capacity: 4, pricePerKm: 65.0, baseFare: 250.0),
    VehicleModel(id: 'v_c2', driverId: 'd_c2', type: VehicleType.car, make: 'Suzuki', model: 'WagonR', year: 2023, plateNumber: 'CAB-3456', color: 'Silver', capacity: 4, pricePerKm: 50.0, baseFare: 200.0),
    VehicleModel(id: 'v_c3', driverId: 'd_c3', type: VehicleType.car, make: 'Honda', model: 'Vezel', year: 2022, plateNumber: 'CAB-7890', color: 'Gray', capacity: 4, pricePerKm: 75.0, baseFare: 300.0),
    // Vans
    VehicleModel(id: 'v_v1', driverId: 'd_v1', type: VehicleType.van, make: 'Toyota', model: 'KDH 200', year: 2021, plateNumber: 'VAN-9012', color: 'Silver', capacity: 8, pricePerKm: 85.0, baseFare: 400.0),
    VehicleModel(id: 'v_v2', driverId: 'd_v2', type: VehicleType.van, make: 'Nissan', model: 'Caravan', year: 2020, plateNumber: 'VAN-3456', color: 'White', capacity: 10, pricePerKm: 90.0, baseFare: 450.0),
  ];

  static Future<List<VehicleModel>> getVehicles({VehicleType? type}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (type != null) {
      return _vehicles.where((v) => v.type == type).toList();
    }
    return _vehicles;
  }

  static Future<List<VehicleModel>> getNearbyVehicles() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _vehicles.where((v) => v.isAvailable).toList();
  }

  static VehicleModel? getVehicleById(String id) {
    try {
      return _vehicles.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }
}
