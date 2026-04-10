import 'package:equatable/equatable.dart';

enum VehicleType { bike, car, van }

class VehicleModel extends Equatable {
  final String id;
  final String driverId;
  final VehicleType type;
  final String make;
  final String model;
  final int year;
  final String plateNumber;
  final String color;
  final int capacity;
  final double pricePerKm;
  final double baseFare;
  final String? imageUrl;
  final bool isAvailable;

  const VehicleModel({
    required this.id,
    required this.driverId,
    required this.type,
    required this.make,
    required this.model,
    required this.year,
    required this.plateNumber,
    required this.color,
    this.capacity = 4,
    required this.pricePerKm,
    required this.baseFare,
    this.imageUrl,
    this.isAvailable = true,
  });

  String get displayName => '$make $model';
  String get typeLabel {
    switch (type) {
      case VehicleType.bike:
        return 'Bike';
      case VehicleType.car:
        return 'Car';
      case VehicleType.van:
        return 'Van';
    }
  }

  @override
  List<Object?> get props => [id];
}
