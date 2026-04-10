import 'package:equatable/equatable.dart';

enum UserRole { rider, driver, admin }

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
  final UserRole role;
  final double rating;
  final int totalRides;
  final DateTime createdAt;
  final List<SavedLocation> savedLocations;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
    this.role = UserRole.rider,
    this.rating = 5.0,
    this.totalRides = 0,
    required this.createdAt,
    this.savedLocations = const [],
  });

  @override
  List<Object?> get props => [id, email];

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    double? rating,
    int? totalRides,
    List<SavedLocation>? savedLocations,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role,
      rating: rating ?? this.rating,
      totalRides: totalRides ?? this.totalRides,
      createdAt: createdAt,
      savedLocations: savedLocations ?? this.savedLocations,
    );
  }
}

class SavedLocation extends Equatable {
  final String id;
  final String label;
  final String address;
  final double latitude;
  final double longitude;
  final String icon;

  const SavedLocation({
    required this.id,
    required this.label,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.icon = 'location_on',
  });

  @override
  List<Object?> get props => [id];
}
