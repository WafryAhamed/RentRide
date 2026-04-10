import 'package:equatable/equatable.dart';
import 'vehicle_model.dart';
import 'driver_model.dart';
import 'location_model.dart';

enum RideStatus {
  searching,
  driverFound,
  driverArriving,
  driverArrived,
  inProgress,
  completed,
  cancelled,
}

class RideModel extends Equatable {
  final String id;
  final String userId;
  final String? driverId;
  final DriverModel? driver;
  final VehicleModel? vehicle;
  final LocationModel pickup;
  final LocationModel dropoff;
  final RideStatus status;
  final double fare;
  final double distanceKm;
  final int durationMin;
  final int? estimatedArrivalMin;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const RideModel({
    required this.id,
    required this.userId,
    this.driverId,
    this.driver,
    this.vehicle,
    required this.pickup,
    required this.dropoff,
    this.status = RideStatus.searching,
    this.fare = 0,
    this.distanceKm = 0,
    this.durationMin = 0,
    this.estimatedArrivalMin,
    this.paymentMethod = 'Cash',
    required this.createdAt,
    this.startedAt,
    this.completedAt,
  });

  String get statusLabel {
    switch (status) {
      case RideStatus.searching:
        return 'Searching for driver...';
      case RideStatus.driverFound:
        return 'Driver found!';
      case RideStatus.driverArriving:
        return 'Driver is on the way';
      case RideStatus.driverArrived:
        return 'Driver has arrived';
      case RideStatus.inProgress:
        return 'Ride in progress';
      case RideStatus.completed:
        return 'Ride completed';
      case RideStatus.cancelled:
        return 'Ride cancelled';
    }
  }

  RideModel copyWith({
    RideStatus? status,
    DriverModel? driver,
    VehicleModel? vehicle,
    String? driverId,
    double? fare,
    double? distanceKm,
    int? durationMin,
    int? estimatedArrivalMin,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return RideModel(
      id: id,
      userId: userId,
      driverId: driverId ?? this.driverId,
      driver: driver ?? this.driver,
      vehicle: vehicle ?? this.vehicle,
      pickup: pickup,
      dropoff: dropoff,
      status: status ?? this.status,
      fare: fare ?? this.fare,
      distanceKm: distanceKm ?? this.distanceKm,
      durationMin: durationMin ?? this.durationMin,
      estimatedArrivalMin: estimatedArrivalMin ?? this.estimatedArrivalMin,
      paymentMethod: paymentMethod,
      createdAt: createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [id];
}
