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
