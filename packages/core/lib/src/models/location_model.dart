import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  final double latitude;
  final double longitude;
  final String address;
  final String? name;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.name,
  });

  String get displayName => name ?? address;

  @override
  List<Object?> get props => [latitude, longitude];
}
