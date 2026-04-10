import '../models/travel_guide_model.dart';

/// Mock travel guide service with Sri Lankan destinations.
class MockGuideService {
  static final List<TravelGuideModel> _guides = const [
    // Hotels
    TravelGuideModel(
      id: 'g_h1', title: 'Shangri-La Colombo', description: 'A luxury 5-star hotel located at the One Galle Face development with stunning ocean views, multiple dining options, and world-class spa facilities.',
      category: GuideCategory.hotels, latitude: 6.9271, longitude: 79.8462, address: '1 Galle Face, Colombo 02',
      rating: 4.8, reviewCount: 2340, priceRange: '\$\$\$\$', openingHours: '24 hours', tags: ['luxury', 'ocean view', 'spa', '5-star'], distanceKm: 2.1,
    ),
    TravelGuideModel(
      id: 'g_h2', title: 'Cinnamon Grand', description: 'Iconic 5-star hotel in the heart of Colombo, offering elegance, fine dining, and premium hospitality experience.',
      category: GuideCategory.hotels, latitude: 6.9175, longitude: 79.8487, address: '77 Galle Road, Colombo 03',
      rating: 4.6, reviewCount: 1890, priceRange: '\$\$\$', openingHours: '24 hours', tags: ['luxury', 'business', 'dining'], distanceKm: 1.5,
    ),
    // Restaurants
    TravelGuideModel(
      id: 'g_r1', title: 'Ministry of Crab', description: 'World-renowned restaurant by cricketers Mahela and Kumar, famous for its Sri Lankan crab dishes served in a historic Dutch Hospital setting.',
      category: GuideCategory.restaurants, latitude: 6.9340, longitude: 79.8429, address: 'Dutch Hospital, Colombo 01',
      rating: 4.7, reviewCount: 5600, priceRange: '\$\$\$', openingHours: '12:00 PM - 10:30 PM', tags: ['seafood', 'crab', 'celebrity chef'], distanceKm: 3.2,
    ),
    TravelGuideModel(
      id: 'g_r2', title: 'Upali\'s by Nawaloka', description: 'Authentic Sri Lankan cuisine in a modern setting. Known for traditional rice & curry, hoppers, and local favorites.',
      category: GuideCategory.restaurants, latitude: 6.9271, longitude: 79.8584, address: '65 C.W.W. Kannangara Mw, Colombo 07',
      rating: 4.5, reviewCount: 3200, priceRange: '\$\$', openingHours: '11:00 AM - 10:00 PM', tags: ['sri lankan', 'rice & curry', 'traditional'], distanceKm: 1.8,
    ),
    // Tourist Places
    TravelGuideModel(
      id: 'g_t1', title: 'Sigiriya Rock Fortress', description: 'Ancient rock fortress and palace ruin, a UNESCO World Heritage Site rising 200m above the surrounding jungle. One of Sri Lanka\'s most iconic landmarks.',
      category: GuideCategory.touristPlaces, latitude: 7.9571, longitude: 80.7603, address: 'Sigiriya, Central Province',
      rating: 4.9, reviewCount: 12500, priceRange: '\$', openingHours: '7:00 AM - 5:30 PM', tags: ['UNESCO', 'history', 'views', 'must-see'], distanceKm: 169.0,
    ),
    TravelGuideModel(
      id: 'g_t2', title: 'Temple of the Tooth', description: 'Sri Dalada Maligawa — a sacred Buddhist temple housing the relic of the tooth of Buddha, located in the royal palace complex in Kandy.',
      category: GuideCategory.temples, latitude: 7.2936, longitude: 80.6413, address: 'Sri Dalada Veediya, Kandy',
      rating: 4.8, reviewCount: 8900, priceRange: '\$', openingHours: '5:30 AM - 8:00 PM', tags: ['UNESCO', 'Buddhist', 'sacred', 'cultural'], distanceKm: 116.0,
    ),
    // Beaches
    TravelGuideModel(
      id: 'g_b1', title: 'Unawatuna Beach', description: 'A stunning crescent-shaped bay with golden sand, calm turquoise waters, and a vibrant beach scene with restaurants and water sports.',
      category: GuideCategory.beaches, latitude: 6.0098, longitude: 80.2497, address: 'Unawatuna, Galle',
      rating: 4.6, reviewCount: 6700, openingHours: 'Open 24 hours', tags: ['swimming', 'surfing', 'snorkeling'], distanceKm: 130.0,
    ),
    TravelGuideModel(
      id: 'g_b2', title: 'Mirissa Beach', description: 'Famous for whale watching, surfing, and breathtaking sunsets. A quieter alternative to busier southern beaches.',
      category: GuideCategory.beaches, latitude: 5.9489, longitude: 80.4528, address: 'Mirissa, Matara',
      rating: 4.7, reviewCount: 5400, openingHours: 'Open 24 hours', tags: ['whale watching', 'surfing', 'sunset'], distanceKm: 155.0,
    ),
    // Parks
    TravelGuideModel(
      id: 'g_p1', title: 'Viharamahadevi Park', description: 'Colombo\'s largest and oldest park, featuring beautiful walking paths, playgrounds, a mini zoo, and stunning flower displays.',
      category: GuideCategory.parks, latitude: 6.9147, longitude: 79.8609, address: 'Colombo 07',
      rating: 4.3, reviewCount: 3200, openingHours: '6:00 AM - 6:00 PM', tags: ['walking', 'nature', 'family'], distanceKm: 0.8,
    ),
  ];

  static Future<List<TravelGuideModel>> getAllGuides() async {
    await Future.delayed(const Duration(seconds: 1));
    return _guides;
  }

  static Future<List<TravelGuideModel>> getByCategory(GuideCategory category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _guides.where((g) => g.category == category).toList();
  }

  static Future<List<TravelGuideModel>> getNearbyPlaces({double maxDistanceKm = 10}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _guides.where((g) => (g.distanceKm ?? 999) <= maxDistanceKm).toList();
  }

  static Future<TravelGuideModel?> getGuideById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _guides.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }
}
