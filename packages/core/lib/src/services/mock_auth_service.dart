import '../models/user_model.dart';

/// Mock authentication service for development.
class MockAuthService {
  static UserModel? _currentUser;

  static final UserModel _mockUser = UserModel(
    id: 'user_001',
    name: 'Sahan Perera',
    email: 'sahan@rentride.lk',
    phone: '+94 77 123 4567',
    avatarUrl: null,
    role: UserRole.rider,
    rating: 4.8,
    totalRides: 42,
    createdAt: DateTime(2024, 1, 15),
    savedLocations: const [
      SavedLocation(
        id: 'loc_1',
        label: 'Home',
        address: '23, Galle Road, Colombo 03',
        latitude: 6.9271,
        longitude: 79.8612,
        icon: 'home',
      ),
      SavedLocation(
        id: 'loc_2',
        label: 'Work',
        address: 'World Trade Center, Colombo 01',
        latitude: 6.9344,
        longitude: 79.8428,
        icon: 'work',
      ),
    ],
  );

  static Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    _currentUser = _mockUser;
    return _mockUser;
  }

  static Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    _currentUser = _mockUser.copyWith(name: name, email: email, phone: phone);
    return _currentUser!;
  }

  static Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return otp == '1234';
  }

  static Future<void> sendOtp(String phone) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  static UserModel? get currentUser => _currentUser;
  static bool get isLoggedIn => _currentUser != null;
}
