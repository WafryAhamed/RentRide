/// RentRide Core Package
/// Shared models, theme, widgets, and services for User & Driver apps.
library;

// Theme & Design System
export 'src/theme/app_colors.dart';
export 'src/theme/app_theme.dart';
export 'src/theme/app_text_styles.dart';
export 'src/theme/app_spacing.dart';

// Models
export 'src/models/user_model.dart';
export 'src/models/vehicle_model.dart';
export 'src/models/ride_model.dart';
export 'src/models/location_model.dart';
export 'src/models/notification_model.dart';
export 'src/models/travel_guide_model.dart';
export 'src/models/rating_model.dart';
export 'src/models/driver_model.dart';

// Services
export 'src/services/mock_auth_service.dart';
export 'src/services/mock_ride_service.dart';
export 'src/services/mock_vehicle_service.dart';
export 'src/services/mock_guide_service.dart';
export 'src/services/mock_notification_service.dart';

// Widgets
export 'src/widgets/rent_ride_button.dart';
export 'src/widgets/rent_ride_text_field.dart';
export 'src/widgets/glass_card.dart';
export 'src/widgets/ride_card.dart';
export 'src/widgets/vehicle_card.dart';
export 'src/widgets/map_view.dart';
export 'src/widgets/loading_shimmer.dart';
export 'src/widgets/status_badge.dart';
export 'src/widgets/rating_stars.dart';
export 'src/widgets/animated_gradient_bg.dart';

// Utils
export 'src/utils/formatters.dart';
export 'src/utils/validators.dart';
export 'src/utils/constants.dart';
