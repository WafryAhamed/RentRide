import 'package:equatable/equatable.dart';

enum GuideCategory { hotels, restaurants, touristPlaces, temples, beaches, parks }

class TravelGuideModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final GuideCategory category;
  final List<String> images;
  final double latitude;
  final double longitude;
  final String address;
  final double rating;
  final int reviewCount;
  final String? priceRange;
  final String? openingHours;
  final List<String> tags;
  final double? distanceKm;

  const TravelGuideModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.images = const [],
    required this.latitude,
    required this.longitude,
    required this.address,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.priceRange,
    this.openingHours,
    this.tags = const [],
    this.distanceKm,
  });

  factory TravelGuideModel.fromJson(Map<String, dynamic> json) {
    return TravelGuideModel(
      id: json['id']?.toString() ?? '',
      title: json['name'] ?? json['title'] ?? '',
      description: json['description'] ?? '',
      category: GuideCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => GuideCategory.touristPlaces,
      ),
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      latitude: json['latitude'] != null ? double.parse(json['latitude'].toString()) : 0.0,
      longitude: json['longitude'] != null ? double.parse(json['longitude'].toString()) : 0.0,
      address: json['city'] ?? json['address'] ?? '',
      rating: json['rating'] != null ? double.parse(json['rating'].toString()) : 0.0,
      reviewCount: json['review_count'] ?? 0,
      openingHours: json['opening_hours'],
    );
  }


  String get categoryLabel {
    switch (category) {
      case GuideCategory.hotels:
        return 'Hotels';
      case GuideCategory.restaurants:
        return 'Restaurants';
      case GuideCategory.touristPlaces:
        return 'Tourist Places';
      case GuideCategory.temples:
        return 'Temples';
      case GuideCategory.beaches:
        return 'Beaches';
      case GuideCategory.parks:
        return 'Parks';
    }
  }

  String get categoryIcon {
    switch (category) {
      case GuideCategory.hotels:
        return '🏨';
      case GuideCategory.restaurants:
        return '🍽️';
      case GuideCategory.touristPlaces:
        return '🗺️';
      case GuideCategory.temples:
        return '🛕';
      case GuideCategory.beaches:
        return '🏖️';
      case GuideCategory.parks:
        return '🌳';
    }
  }

  @override
  List<Object?> get props => [id];
}
