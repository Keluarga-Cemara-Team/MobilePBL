import '../entities/psychologist.dart';

abstract class PsychologistRepository {
  /// Mengambil daftar psikolog / faskes kesehatan mental.
  /// Dapat difilter berdasarkan kota dan diurutkan berdasarkan jarak dari lokasi pengguna.
  Future<List<Psychologist>> getPsychologists({
    String? city,
    double? userLatitude,
    double? userLongitude,
    String? query,
  });
}

