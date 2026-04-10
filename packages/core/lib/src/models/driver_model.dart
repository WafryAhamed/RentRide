import 'package:equatable/equatable.dart';

class DriverModel extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String? avatarUrl;
  final double rating;
  final int totalRides;
  final int totalEarnings;
  final String vehicleId;
  final String? licensePlate;
  final String? vehicleName;
  final double? currentLat;
  final double? currentLng;
  final bool isOnline;
  final bool isOnRide;

  const DriverModel({
    required this.id,
    required this.name,
    required this.phone,
    this.avatarUrl,
    this.rating = 4.8,
    this.totalRides = 0,
    this.totalEarnings = 0,
    required this.vehicleId,
    this.licensePlate,
    this.vehicleName,
    this.currentLat,
    this.currentLng,
    this.isOnline = false,
    this.isOnRide = false,
  });

  DriverModel copyWith({
    bool? isOnline,
    bool? isOnRide,
    double? currentLat,
    double? currentLng,
    double? rating,
    int? totalRides,
    int? totalEarnings,
  }) {
    return DriverModel(
      id: id,
      name: name,
      phone: phone,
      avatarUrl: avatarUrl,
      rating: rating ?? this.rating,
      totalRides: totalRides ?? this.totalRides,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      vehicleId: vehicleId,
      licensePlate: licensePlate,
      vehicleName: vehicleName,
      currentLat: currentLat ?? this.currentLat,
      currentLng: currentLng ?? this.currentLng,
      isOnline: isOnline ?? this.isOnline,
      isOnRide: isOnRide ?? this.isOnRide,
    );
  }

  @override
  List<Object?> get props => [id];
}
