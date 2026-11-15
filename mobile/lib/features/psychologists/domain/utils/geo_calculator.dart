import 'dart:math' as math;

class GeoCalculator {
  static const double earthRadiusKm = 6371.0;

  /// Menghitung jarak garis lurus antara dua titik koordinat GPS dalam satuan kilometer.
  static double distanceBetweenKm({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    final dLat = _deg2rad(endLatitude - startLatitude);
    final dLon = _deg2rad(endLongitude - startLongitude);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(startLatitude)) *
            math.cos(_deg2rad(endLatitude)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _deg2rad(double deg) => deg * (math.pi / 180.0);

  /// Format jarak yang ramah pengguna (contoh: "850 m" atau "2.4 km").
  static String formatDistance(double km) {
    if (km < 1.0) {
      final meters = (km * 1000).round();
      return '$meters m';
    }
    return '${km.toStringAsFixed(1)} km';
  }
}

