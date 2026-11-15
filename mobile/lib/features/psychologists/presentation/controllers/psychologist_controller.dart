import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../di/psychologist_providers.dart';
import '../../domain/repositories/psychologist_repository.dart';
import 'psychologist_state.dart';

final positionResolverProvider = Provider<Future<Position?> Function()>((ref) {
  return () async {
    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 4),
        ),
      );
    } catch (_) {
      return null;
    }
  };
});

class PsychologistController extends Notifier<PsychologistState> {
  PsychologistRepository get _repository =>
      ref.read(psychologistRepositoryProvider);

  @override
  PsychologistState build() {
    Future.microtask(initLocationAndData);
    return const PsychologistState(isLoading: true, isLocating: true);
  }

  Future<void> initLocationAndData() async {
    state = state.copyWith(isLoading: true, isLocating: true);

    double? lat;
    double? lng;
    String locationLabel = 'Kota Batam (Default)';
    bool hasGps = false;

    try {
      final resolver = ref.read(positionResolverProvider);
      final position = await resolver();
      if (position != null) {
        lat = position.latitude;
        lng = position.longitude;
        locationLabel =
            'GPS Terdeteksi (${lat.toStringAsFixed(3)}, ${lng.toStringAsFixed(3)})';
        hasGps = true;
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }

    // Jika GPS tidak aktif/dibatalkan, gunakan koordinat fallback (Batam)
    if (!hasGps) {
      lat = 1.1301;
      lng = 104.0531;
    }

    state = state.copyWith(
      isLocating: false,
      userLatitude: lat,
      userLongitude: lng,
      locationLabel: locationLabel,
      hasGpsLocation: hasGps,
    );

    await refreshData();
  }

  Future<void> refreshData() async {
    state = state.copyWith(isLoading: true);
    try {
      final items = await _repository.getPsychologists(
        city: state.selectedCity,
        userLatitude: state.userLatitude,
        userLongitude: state.userLongitude,
        query: state.searchQuery,
      );
      state = state.copyWith(psychologists: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat data psikolog: $e',
      );
    }
  }

  void setCityFilter(String city) {
    if (state.selectedCity == city) return;
    state = state.copyWith(selectedCity: city);
    refreshData();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    refreshData();
  }
}

final psychologistControllerProvider =
    NotifierProvider<PsychologistController, PsychologistState>(
  PsychologistController.new,
);
