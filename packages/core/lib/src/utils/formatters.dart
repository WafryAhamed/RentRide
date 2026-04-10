import 'package:intl/intl.dart';

/// Formatters for currency, date, distance, and duration.
class Formatters {
  Formatters._();

  static String currency(double amount) {
    return 'Rs. ${NumberFormat('#,##0').format(amount)}';
  }

  static String distance(double km) {
    if (km < 1) {
      return '${(km * 1000).toInt()} m';
    }
    return '${km.toStringAsFixed(1)} km';
  }

  static String duration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '$hours hr';
    return '$hours hr $mins min';
  }

  static String date(DateTime dt) {
    return DateFormat('MMM dd, yyyy').format(dt);
  }

  static String time(DateTime dt) {
    return DateFormat('hh:mm a').format(dt);
  }

  static String dateTime(DateTime dt) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(dt);
  }

  static String relativeTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM dd').format(dt);
  }

  static String rating(double r) => r.toStringAsFixed(1);
}
