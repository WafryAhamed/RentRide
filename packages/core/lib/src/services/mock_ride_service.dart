import '../models/ride_model.dart';
import '../models/vehicle_model.dart';
import '../models/driver_model.dart';
import '../models/location_model.dart';

/// Mock ride service with realistic ride data.
class MockRideService {
  static final List<RideModel> _rideHistory = [
    RideModel(
      id: 'ride_001',
      userId: 'user_001',
      driverId: 'driver_001',
      driver: const DriverModel(
        id: 'driver_001',
        name: 'Kamal Silva',
        phone: '+94 77 234 5678',
        rating: 4.9,
        totalRides: 1250,
        vehicleId: 'v_001',
        licensePlate: 'CAB-1234',
        vehicleName: 'Toyota Prius',
      ),
      vehicle: const VehicleModel(
        id: 'v_001',
        driverId: 'driver_001',
        type: VehicleType.car,
        make: 'Toyota',
        model: 'Prius',
        year: 2022,
        plateNumber: 'CAB-1234',
        color: 'White',
        pricePerKm: 65.0,
        baseFare: 250.0,
      ),
      pickup: const LocationModel(
        latitude: 6.9271,
        longitude: 79.8612,
        address: '23, Galle Road, Colombo 03',
        name: 'Home',
      ),
      dropoff: const LocationModel(
        latitude: 6.9344,
        longitude: 79.8428,
        address: 'World Trade Center, Colombo 01',
        name: 'World Trade Center',
      ),
      status: RideStatus.completed,
      fare: 580.0,
      distanceKm: 5.2,
      durationMin: 18,
      paymentMethod: 'Cash',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      startedAt: DateTime.now().subtract(const Duration(days: 1, hours: 23)),
      completedAt: DateTime.now().subtract(const Duration(days: 1, hours: 22, minutes: 42)),
    ),
    RideModel(
      id: 'ride_002',
      userId: 'user_001',
      driverId: 'driver_002',
      driver: const DriverModel(
        id: 'driver_002',
        name: 'Nuwan Fernando',
        phone: '+94 71 345 6789',
        rating: 4.7,
        totalRides: 830,
        vehicleId: 'v_002',
        licensePlate: 'BIK-5678',
        vehicleName: 'Honda PCX',
      ),
      vehicle: const VehicleModel(
        id: 'v_002',
        driverId: 'driver_002',
        type: VehicleType.bike,
        make: 'Honda',
        model: 'PCX 160',
        year: 2023,
        plateNumber: 'BIK-5678',
        color: 'Black',
        capacity: 1,
        pricePerKm: 35.0,
        baseFare: 100.0,
      ),
      pickup: const LocationModel(
        latitude: 6.9344,
        longitude: 79.8428,
        address: 'World Trade Center, Colombo 01',
        name: 'Work',
      ),
      dropoff: const LocationModel(
        latitude: 6.9147,
        longitude: 79.8728,
        address: 'Bambalapitiya Junction',
        name: 'Bambalapitiya',
      ),
      status: RideStatus.completed,
      fare: 320.0,
      distanceKm: 3.8,
      durationMin: 12,
      paymentMethod: 'Cash',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      startedAt: DateTime.now().subtract(const Duration(days: 3)),
      completedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    RideModel(
      id: 'ride_003',
      userId: 'user_001',
      driverId: 'driver_003',
      driver: const DriverModel(
        id: 'driver_003',
        name: 'Ravi Jayawardena',
        phone: '+94 76 456 7890',
        rating: 4.5,
        totalRides: 450,
        vehicleId: 'v_003',
        licensePlate: 'VAN-9012',
        vehicleName: 'Toyota KDH',
      ),
      vehicle: const VehicleModel(
        id: 'v_003',
        driverId: 'driver_003',
        type: VehicleType.van,
        make: 'Toyota',
        model: 'KDH 200',
        year: 2021,
        plateNumber: 'VAN-9012',
        color: 'Silver',
        capacity: 8,
        pricePerKm: 85.0,
        baseFare: 400.0,
      ),
      pickup: const LocationModel(
        latitude: 6.9271,
        longitude: 79.8612,
        address: '23, Galle Road, Colombo 03',
        name: 'Home',
      ),
      dropoff: const LocationModel(
        latitude: 7.2906,
        longitude: 80.6337,
        address: 'Kandy City Centre',
        name: 'Kandy',
      ),
      status: RideStatus.completed,
      fare: 8500.0,
      distanceKm: 115.0,
      durationMin: 180,
      paymentMethod: 'Cash',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      startedAt: DateTime.now().subtract(const Duration(days: 7)),
      completedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  static Future<List<RideModel>> getRideHistory() async {
    await Future.delayed(const Duration(seconds: 1));
    return _rideHistory;
  }

  static Future<RideModel> createRide({
    required LocationModel pickup,
    required LocationModel dropoff,
    required VehicleType vehicleType,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return RideModel(
      id: 'ride_new_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user_001',
      pickup: pickup,
      dropoff: dropoff,
      status: RideStatus.searching,
      createdAt: DateTime.now(),
    );
  }

  static Future<RideModel> simulateDriverFound(RideModel ride) async {
    await Future.delayed(const Duration(seconds: 3));
    return ride.copyWith(
      status: RideStatus.driverFound,
      driverId: 'driver_001',
      driver: const DriverModel(
        id: 'driver_001',
        name: 'Kamal Silva',
        phone: '+94 77 234 5678',
        rating: 4.9,
        totalRides: 1250,
        vehicleId: 'v_001',
        licensePlate: 'CAB-1234',
        vehicleName: 'Toyota Prius',
        currentLat: 6.9285,
        currentLng: 79.8620,
      ),
      vehicle: const VehicleModel(
        id: 'v_001',
        driverId: 'driver_001',
        type: VehicleType.car,
        make: 'Toyota',
        model: 'Prius',
        year: 2022,
        plateNumber: 'CAB-1234',
        color: 'White',
        pricePerKm: 65.0,
        baseFare: 250.0,
      ),
      estimatedArrivalMin: 5,
      fare: 580.0,
      distanceKm: 5.2,
      durationMin: 18,
    );
  }

  static double calculateFare(double distanceKm, VehicleType type) {
    double baseFare;
    double perKm;
    switch (type) {
      case VehicleType.bike:
        baseFare = 100;
        perKm = 35;
        break;
      case VehicleType.car:
        baseFare = 250;
        perKm = 65;
        break;
      case VehicleType.van:
        baseFare = 400;
        perKm = 85;
        break;
    }
    return baseFare + (distanceKm * perKm);
  }
}
