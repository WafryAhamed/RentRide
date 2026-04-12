import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  final double latitude;
  final double longitude;
  final String address;
  final String? name;
  final double? heading;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.name,
    this.heading,
  });

  String get displayName => name ?? address;

  @override
  List<Object?> get props => [latitude, longitude];
}
